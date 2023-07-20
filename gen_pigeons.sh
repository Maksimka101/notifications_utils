#!/bin/sh

# Script to generate platform channels using pigeon.

ios_swift_out=ios/Classes/NotificationsUtilsInterface.swift
macos_swift_out=macos/Classes/NotificationsUtilsInterface.swift

dart run pigeon \
  --input pigeons/notifications_utils.dart \
  --swift_out $ios_swift_out

cp $ios_swift_out $macos_swift_out

echo "Done!"
