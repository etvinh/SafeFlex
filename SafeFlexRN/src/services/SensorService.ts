export interface SensorReading {
  timestamp: number;
  flex: number;
  stability: number;
}

type Listener = (reading: SensorReading) => void;
type StatusListener = (connected: boolean) => void;

class SensorService {
  private ws: WebSocket | null = null;
  private listeners: Listener[] = [];
  private statusListeners: StatusListener[] = [];
  private serverAddress = '';
  private shouldReconnect = false;

  get isConnected(): boolean {
    return this.ws?.readyState === WebSocket.OPEN;
  }

  connect(address: string) {
    this.disconnect();
    this.serverAddress = address;
    this.shouldReconnect = true;
    const url = `ws://${address}`;
    console.log(`[Sensor] Connecting to ${url}...`);

    this.ws = new WebSocket(url);

    this.ws.onopen = () => {
      console.log('[Sensor] Connected');
      this.notifyStatus(true);
    };

    this.ws.onmessage = (event) => {
      try {
        const reading: SensorReading = JSON.parse(event.data);
        this.listeners.forEach((l) => l(reading));
      } catch (e) {
        console.log('[Sensor] Failed to decode:', event.data);
      }
    };

    this.ws.onerror = (e) => {
      console.log('[Sensor] Error:', e);
    };

    this.ws.onclose = () => {
      console.log('[Sensor] Disconnected');
      this.notifyStatus(false);
      if (this.shouldReconnect) {
        setTimeout(() => {
          if (this.shouldReconnect) {
            console.log('[Sensor] Reconnecting...');
            this.connect(this.serverAddress);
          }
        }, 2000);
      }
    };
  }

  disconnect() {
    this.shouldReconnect = false;
    this.ws?.close();
    this.ws = null;
    this.notifyStatus(false);
  }

  onReading(listener: Listener) {
    this.listeners.push(listener);
    return () => {
      this.listeners = this.listeners.filter((l) => l !== listener);
    };
  }

  onStatusChange(listener: StatusListener) {
    this.statusListeners.push(listener);
    return () => {
      this.statusListeners = this.statusListeners.filter((l) => l !== listener);
    };
  }

  private notifyStatus(connected: boolean) {
    this.statusListeners.forEach((l) => l(connected));
  }
}

export const sensorService = new SensorService();
