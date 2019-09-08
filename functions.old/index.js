const functions = require('firebase-functions');
const express = require('express');
const bodyParser = require('body-parser');
const admin = require('firebase-admin');
const cors = require('cors')({
    origin: true
});

admin.initializeApp(functions.config().firebase);
const settings = {
    timestampsInSnapshots: true
};
admin.firestore().settings(settings);
const db = admin.firestore();
const FieldValue = require('firebase-admin').firestore.FieldValue;

const app = express();
const main = express();

main.use('/api/v1', app);
main.use(bodyParser.json());
main.use(bodyParser.urlencoded({
    extended: false
}))

// exports.webApi = functions.https.onRequest(main);
// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onRequest((request, response) => {
    response.send("Hello from Firebase!");
});

exports.addAdmin = functions.https.onCall((data, context) => {
    if (context.auth.token.coordinator !== true) {
        return {
            error: "Request not authorized. User must be a moderator to fulfill request."
        };
    }
    // const email = data.email;
    return {
        result: `Request fulfilled! is now a moderator.`
    };
});

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
        // return docRef.get()
        //     .then(snapshot => {
        //         let attendance_count = 0
        //         if (snapshot.data() !== undefined || snapshot.data().attendance_count !== undefined) {
        //             attendance_count = snapshot.data().attendance_count + 1;
        //         }
        //         // const attendance_count = snapshot.data().attendance_count + 1;

        //         const data = { attendance_count };

        //         return docRef.update(data);
        //     });
    });