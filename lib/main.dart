import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

import 'package:cynergy_app/app/App.dart';
import 'package:cynergy_app/bloc_delegates/SimpleBlocDelegate.dart';
import 'package:cynergy_app/repository/UserRepository.dart';
import 'package:cynergy_app/services/LoginAuth.dart';


void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App(userRepository: UserRepository(auth: LoginAuth())));
}
