//
//  JailbreakDetector.swift
//  Rello
//
//  Created by Aleksandr Shepelenok on 21.03.23.
//

import Foundation

import Foundation

public class JailbreakDetector {

    public var isJailbreakDetected: Bool {
        guard !Platform.isSimulator else { return false }
        return hasCydiaInstalled || isContainsSuspiciousApps || isSuspiciousSystemPathsExists || canEditSystemFiles
    }

    private var hasCydiaInstalled: Bool {
        UIApplication.shared.canOpenURL(URL(string: "cydia://")!)
    }

    private var isContainsSuspiciousApps: Bool {
        for path in suspiciousApplicationPathsToCheck {
            if FileManager.default.fileExists(atPath: path) { return true }
        }
        return false
    }

    private var isSuspiciousSystemPathsExists: Bool {
        for path in suspiciousSystemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) { return true }
        }
        return false
    }

    private var canEditSystemFiles: Bool {
        let jailbreakText = "jailbreak_check"
        do {
            try jailbreakText.write(toFile: jailbreakText, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }

    private var suspiciousApplicationPathsToCheck: [String] {
        return ["/Applications/Cydia.app",
                "/Applications/blackra1n.app",
                "/Applications/FakeCarrier.app",
                "/Applications/Icy.app",
                "/Applications/IntelliScreen.app",
                "/Applications/MxTube.app",
                "/Applications/RockApp.app",
                "/Applications/SBSettings.app",
                "/Applications/WinterBoard.app"
        ]
    }

    private var suspiciousSystemPathsToCheck: [String] {
        return ["/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                "/private/var/lib/apt",
                "/private/var/lib/apt/",
                "/private/var/lib/cydia",
                "/private/var/mobile/Library/SBSettings/Themes",
                "/private/var/stash",
                "/private/var/tmp/cydia.log",
                "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                "/usr/bin/sshd",
                "/usr/libexec/sftp-server",
                "/usr/sbin/sshd",
                "/etc/apt",
                "/bin/bash",
                "/Library/MobileSubstrate/MobileSubstrate.dylib"
        ]
    }
}
