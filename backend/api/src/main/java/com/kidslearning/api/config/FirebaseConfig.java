package com.kidslearning.api.config;

import org.springframework.context.annotation.Configuration;

/**
 * Firebase configuration. In the default/test profile, we use InMemoryFirebaseRepository.
 * For production, this would initialize FirebaseApp with service account credentials.
 */
@Configuration
public class FirebaseConfig {
    // In default profile, InMemoryFirebaseRepository is auto-wired via @Repository annotation.
    // For production, uncomment and configure FirebaseApp bean with GOOGLE_APPLICATION_CREDENTIALS.
}
