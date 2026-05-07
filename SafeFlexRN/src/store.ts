import { createContext, useContext } from 'react';

export interface AppState {
  isAuthenticated: boolean;
  setAuthenticated: (v: boolean) => void;
  sensorAddress: string;
  setSensorAddress: (v: string) => void;
}

export const AppContext = createContext<AppState>({
  isAuthenticated: false,
  setAuthenticated: () => {},
  sensorAddress: '10.0.0.138:8080',
  setSensorAddress: () => {},
});

export const useAppState = () => useContext(AppContext);
