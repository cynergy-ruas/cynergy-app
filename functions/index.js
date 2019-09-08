const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
admin.firestore().settings({
    timestampsInSnapshots: true
})

//////////////////////////////////////////////////////////////////////////
// notify on new event creation
exports.newSessionNotify = functions.firestore.document("/EventsList/{eventId}")
    .onCreate((snapshot, context) => {
        const data = snapshot.data();
        const name = data.eventName;

        const payload = {
            notification: {
                title: "New Event!",
                body: `${name} is comming up!` 
            }
        };

        return admin.messaging().sendToTopic("new_events", payload)
        .then((response) => {
            console.log(`Notification for event ${name} sent sucessfully`);
        })
        .catch((error) => {
            console.error(`Error sending notification for ${name}`);
        });
    });
//////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////
// creating admin

exports.updateAdmin = functions.https.onCall(async (data, context) => {
    console.log(data);

    // if user is not a coordinator, error.
    if (context.auth.token.coordinator !== true && context.auth.token.clearance > 1) {
        return {
            error: "Request not authorized."
        };
    };

    // getting the email of the user who should be made as a coordinator
    const email = data.email;
    // getting the clearance level to be set
    const clearance = data.clearance;
    // updation contains whether the user should be made into a coordinator
    // or not.
    const updation = data.updation;
    // updating clearance
    return updateClearance(email, clearance, updation);
});

async function updateClearance(email, clearance, updation) {
    // getting the user data of the said user
    const user = await admin.auth().getUserByEmail(email);

    // if the user is already a coordinator, return
    if (user.customClaims && user.customClaims.coordinator === updation) {
        return {
            data: `claims updation: ${updation} and clearance: ${clearance} already set for ${email}`
        };
    }
    
    // set claims for the user, return message.
    await admin.auth().setCustomUserClaims(user.uid, {
        coordinator: updation,
        clearance: clearance
    })

    return {
        data: `Request fulfilled! updation: ${updation} and clearance: ${clearance} updated for ${email}!`
    }
}

//////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////
// updating leaderboard

exports.updateLeaderboard = functions.https.onRequest(async (req, res) => {
    try {
        const users = await admin.firestore().collection('Users').get();
        users.docs.forEach(async (user) => {
            if (user.data().uid !== undefined && (user.data().name !== undefined)) {
                const attendance = await user.ref.collection('attendance').doc('attendance_count').get();
                if (attendance.data() !== undefined && attendance.data().attendance_count !== undefined) {
                    let points = await attendance.data().attendance_count * 5;
                    // if (isNaN(points))
                    //     points = 0;
                    // console.log(points);
                    const currentUser = await user.data();
                    const toAdd = {
                        name: user.data().name,
                        points: points
                    }
                    await admin.firestore().collection('Leaderboard').doc(user.ref.id).set(toAdd, {
                        merge: true
                    });
                }
            }
        })
        res.status(200).send({
            status: 'OK'
        });
    } catch (error) {
        console.log(error);
        res.status(500).send(error);
    }
});

//////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////
// updating attendance

exports.attendanceCount = functions.firestore.document('Users/{userId}/events_attended/{eventId}')
    .onWrite((change, context) => {
        const userId = context.params.userId;
        const docRef = admin.firestore().collection('Users').doc(userId).collection('attendance').doc('attendance_count');
        const eventsRef = admin.firestore().collection('Users').doc(userId).collection('events_attended');

        return eventsRef.get()
            .then(snapshot => {
                return snapshot.size;
            })
            .then(value => {
                return docRef.set({
                    attendance_count: value
                })
            });
    });

//////////////////////////////////////////////////////////////////////////
