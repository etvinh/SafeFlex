import { useEffect, useState } from 'react';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { AppContext } from '../src/store';

export default function RootLayout() {
  const [isAuthenticated, setAuthenticated] = useState(false);
  const [sensorAddress, setSensorAddress] = useState('10.0.0.138:8080');

  return (
    <AppContext.Provider
      value={{ isAuthenticated, setAuthenticated, sensorAddress, setSensorAddress }}
    >
      <StatusBar style={isAuthenticated ? 'dark' : 'light'} />
      <Stack screenOptions={{ headerShown: false }}>
        {isAuthenticated ? (
          <>
            <Stack.Screen name="(tabs)" />
            <Stack.Screen
              name="live-session"
              options={{ presentation: 'fullScreenModal', animation: 'slide_from_bottom' }}
            />
            <Stack.Screen
              name="session-results"
              options={{ presentation: 'fullScreenModal', animation: 'slide_from_bottom' }}
            />
            <Stack.Screen
              name="device-settings"
              options={{ presentation: 'modal' }}
            />
            <Stack.Screen
              name="personal-info"
              options={{ presentation: 'modal' }}
            />
            <Stack.Screen
              name="upload-protocol"
              options={{ presentation: 'modal' }}
            />
          </>
        ) : (
          <Stack.Screen name="(auth)" />
        )}
      </Stack>
    </AppContext.Provider>
  );
}
