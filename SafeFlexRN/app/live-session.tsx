import { useState, useEffect, useRef, useCallback } from 'react';
import {
  View, Text, TouchableOpacity, TextInput, Alert, StyleSheet, Animated,
} from 'react-native';
import { router } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Theme } from '../src/theme';
import { useAppState } from '../src/store';
import { sensorService, SensorReading } from '../src/services/SensorService';

const TOTAL_REPS = 12;
const TOTAL_SETS = 3;

function PillBadge({ text, bg, fg }: { text: string; bg: string; fg: string }) {
  return (
    <View style={[styles.pill, { backgroundColor: bg }]}>
      <Text style={[styles.pillText, { color: fg }]}>{text}</Text>
    </View>
  );
}

function MetricBar({ value, label, displayValue }: { value: number; label: string; displayValue: string }) {
  const fillHeight = (170 * Math.min(100, Math.max(0, value))) / 100;
  return (
    <View style={styles.metricBarCol}>
      <View style={styles.metricBarOuter}>
        <View style={[styles.metricBarFill, { height: fillHeight }]} />
      </View>
      <Text style={styles.metricLabel}>{label.toUpperCase()}</Text>
      <Text style={styles.metricValue}>{displayValue}</Text>
    </View>
  );
}

export default function LiveSessionScreen() {
  const { sensorAddress } = useAppState();
  const [seconds, setSeconds] = useState(0);
  const [reps, setReps] = useState(0);
  const [currentSet, setCurrentSet] = useState(1);
  const [isPaused, setIsPaused] = useState(false);
  const [isConnected, setIsConnected] = useState(false);
  const [flex, setFlex] = useState(0);
  const [stability, setStability] = useState(0);
  const flexWasAboveHalf = useRef(false);
  const flashAnim = useRef(new Animated.Value(1)).current;

  const flexPercent = Math.min(100, Math.max(0, Math.round((flex / 1000) * 100)));
  const stabilityPercent = Math.min(100, Math.max(0, Math.round((stability / 5) * 100)));
  const progress = Math.min(reps, TOTAL_REPS) / TOTAL_REPS;
  const overallProgress =
    ((currentSet - 1) * TOTAL_REPS + Math.min(reps, TOTAL_REPS)) / (TOTAL_SETS * TOTAL_REPS);
  const timeFormatted = `${String(Math.floor(seconds / 60)).padStart(2, '0')}:${String(seconds % 60).padStart(2, '0')}`;

  const countRep = useCallback(() => {
    setReps((prev) => {
      const next = prev + 1;
      Animated.sequence([
        Animated.timing(flashAnim, { toValue: 1.1, duration: 150, useNativeDriver: true }),
        Animated.timing(flashAnim, { toValue: 1, duration: 150, useNativeDriver: true }),
      ]).start();

      if (next >= TOTAL_REPS) {
        if (currentSet >= TOTAL_SETS) {
          setTimeout(() => {
            sensorService.disconnect();
            router.replace('/session-results');
          }, 800);
        } else {
          setTimeout(() => {
            setCurrentSet((s) => s + 1);
            setReps(0);
            flexWasAboveHalf.current = false;
          }, 500);
        }
      }
      return next;
    });
  }, [currentSet, flashAnim]);

  useEffect(() => {
    sensorService.connect(sensorAddress);

    const unsubReading = sensorService.onReading((reading: SensorReading) => {
      setFlex(reading.flex);
      setStability(reading.stability);

      const pct = Math.min(100, Math.max(0, Math.round((reading.flex / 1000) * 100)));
      if (pct >= 50) {
        flexWasAboveHalf.current = true;
      } else if (flexWasAboveHalf.current) {
        flexWasAboveHalf.current = false;
        countRep();
      }
    });

    const unsubStatus = sensorService.onStatusChange((connected) => {
      setIsConnected(connected);
    });

    return () => {
      unsubReading();
      unsubStatus();
      sensorService.disconnect();
    };
  }, [sensorAddress, countRep]);

  useEffect(() => {
    const timer = setInterval(() => {
      if (!isPaused) setSeconds((s) => s + 1);
    }, 1000);
    return () => clearInterval(timer);
  }, [isPaused]);

  const showServerConfig = () => {
    Alert.prompt(
      'Sensor Address',
      'Enter your Mac\'s IP and port (e.g. 192.168.1.42:8080)',
      (text) => {
        if (text) sensorService.connect(text);
      },
      'plain-text',
      sensorAddress,
    );
  };

  return (
    <View style={styles.container}>
      {/* App bar */}
      <View style={styles.appBar}>
        <View style={styles.appBarLeft}>
          <View style={styles.sjCircle}>
            <Text style={styles.sjText}>SJ</Text>
          </View>
          <Text style={styles.appBarTitle}>SafeFlex</Text>
        </View>
        <TouchableOpacity
          style={[styles.connBadge, isConnected ? styles.connBadgeOn : styles.connBadgeOff]}
          onPress={showServerConfig}
        >
          <View style={[styles.connDot, { backgroundColor: isConnected ? Theme.success : '#DC2626' }]} />
          <Text style={[styles.connText, { color: isConnected ? '#15803D' : '#DC2626' }]}>
            {isConnected ? 'CONNECTED' : 'DISCONNECTED'}
          </Text>
        </TouchableOpacity>
      </View>

      {/* Exercise info */}
      <View style={styles.exerciseInfo}>
        <Text style={styles.exName}>Shoulder Abduction</Text>
        <Text style={styles.exDesc}>
          Maintain steady tension. Lift arm smoothly to shoulder height.
        </Text>
        <View style={styles.pillRow}>
          <PillBadge text={`Set ${currentSet}/${TOTAL_SETS}`} bg="#EFF6FF" fg={Theme.primary} />
          <PillBadge text={`Rep ${Math.min(reps, TOTAL_REPS)}/${TOTAL_REPS}`} bg="#F0FDF4" fg="#15803D" />
        </View>
      </View>

      {/* Central metrics */}
      <View style={styles.metricsRow}>
        <MetricBar
          value={isConnected ? flexPercent : 0}
          label="Flex"
          displayValue={isConnected ? String(Math.round(flex)) : '—'}
        />

        <View style={styles.centerCol}>
          {/* Timer */}
          <View style={styles.timerPill}>
            <Ionicons name="timer-outline" size={11} color={Theme.primary} />
            <Text style={styles.timerText}>{timeFormatted}</Text>
          </View>

          {/* Rep ring */}
          <View style={styles.repRing}>
            <View style={styles.repRingBg} />
            <View style={styles.repRingInner}>
              <Text style={styles.repLabel}>REPETITION</Text>
              <Animated.Text style={[styles.repCount, { transform: [{ scale: flashAnim }] }]}>
                {Math.min(reps, TOTAL_REPS)}
              </Animated.Text>
              <View style={styles.dotRow}>
                {Array.from({ length: TOTAL_REPS }).map((_, i) => (
                  <View
                    key={i}
                    style={[
                      styles.repDot,
                      i < reps ? styles.repDotActive : null,
                    ]}
                  />
                ))}
              </View>
            </View>
          </View>
        </View>

        <MetricBar
          value={isConnected ? stabilityPercent : 0}
          label="Stability"
          displayValue={isConnected ? stability.toFixed(1) : '—'}
        />
      </View>

      {/* Actions */}
      <View style={styles.actions}>
        <TouchableOpacity
          style={styles.stopBtn}
          onPress={() => {
            sensorService.disconnect();
            router.replace('/session-results');
          }}
          activeOpacity={0.8}
        >
          <Ionicons name="stop-circle" size={14} color="#fff" />
          <Text style={styles.stopText}>STOP — I'M IN PAIN</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.pauseBtn}
          onPress={() => setIsPaused(!isPaused)}
          activeOpacity={0.7}
        >
          <Ionicons name={isPaused ? 'play' : 'pause'} size={11} color={isPaused ? Theme.primary : Theme.secondary} />
          <Text style={[styles.pauseText, isPaused && { color: Theme.primary }]}>
            {isPaused ? 'Resume Session' : 'Pause Session'}
          </Text>
        </TouchableOpacity>
      </View>

      {/* Progress bar */}
      <View style={styles.progressBar}>
        <View style={[styles.progressFill, { width: `${overallProgress * 100}%` }]} />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Theme.surface },
  appBar: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
    paddingHorizontal: 18, height: 64, backgroundColor: '#fff',
  },
  appBarLeft: { flexDirection: 'row', alignItems: 'center', gap: 9 },
  sjCircle: {
    width: 30, height: 30, borderRadius: 15,
    backgroundColor: Theme.primary,
    alignItems: 'center', justifyContent: 'center',
  },
  sjText: { fontSize: 11, fontWeight: '800', color: '#fff' },
  appBarTitle: { fontSize: 16, fontWeight: '800', color: Theme.primary, letterSpacing: -0.3 },
  connBadge: {
    flexDirection: 'row', alignItems: 'center', gap: 5,
    paddingHorizontal: 10, height: 24, borderRadius: 12,
    borderWidth: 1,
  },
  connBadgeOn: { backgroundColor: '#F0FDF4', borderColor: '#BBF7D0' },
  connBadgeOff: { backgroundColor: '#FEF2F2', borderColor: '#FECACA' },
  connDot: { width: 6, height: 6, borderRadius: 3 },
  connText: { fontSize: 9, fontWeight: '800', letterSpacing: 1 },
  exerciseInfo: { alignItems: 'center', paddingHorizontal: 20, paddingTop: 16 },
  exName: { fontSize: 15, fontWeight: '700', color: Theme.onSurface },
  exDesc: { fontSize: 11, color: Theme.secondary, textAlign: 'center', lineHeight: 16, marginTop: 3 },
  pillRow: { flexDirection: 'row', gap: 6, marginTop: 8 },
  pill: { paddingHorizontal: 9, height: 20, borderRadius: 10, justifyContent: 'center' },
  pillText: { fontSize: 10, fontWeight: '700' },
  metricsRow: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
    paddingHorizontal: 12, flex: 1, gap: 8,
  },
  metricBarCol: { alignItems: 'center', gap: 4 },
  metricBarOuter: {
    width: 40, height: 170, borderRadius: 12,
    backgroundColor: 'rgba(225,226,237,0.38)',
    borderWidth: 1, borderColor: 'rgba(225,226,237,0.5)',
    overflow: 'hidden', justifyContent: 'flex-end',
  },
  metricBarFill: {
    width: 40, borderRadius: 2,
    backgroundColor: Theme.success,
    shadowColor: Theme.success, shadowOpacity: 0.28, shadowRadius: 4,
    shadowOffset: { width: 0, height: -2 },
  },
  metricLabel: { fontSize: 8, fontWeight: '700', color: Theme.secondary, letterSpacing: 0.6 },
  metricValue: { fontSize: 14, fontWeight: '800', color: Theme.onSurface },
  centerCol: { alignItems: 'center', gap: 8 },
  timerPill: {
    flexDirection: 'row', alignItems: 'center', gap: 7,
    paddingHorizontal: 14, height: 36, backgroundColor: '#fff',
    borderRadius: 18, borderWidth: 1, borderColor: 'rgba(195,198,215,0.5)',
    shadowColor: '#000', shadowOpacity: 0.06, shadowRadius: 2,
    shadowOffset: { width: 0, height: 1 },
  },
  timerText: {
    fontSize: 16, fontWeight: '800', color: Theme.primary,
    fontVariant: ['tabular-nums'], letterSpacing: 1,
  },
  repRing: {
    width: 170, height: 170, borderRadius: 85,
    borderWidth: 15, borderColor: 'rgba(225,226,237,0.5)',
    alignItems: 'center', justifyContent: 'center',
  },
  repRingBg: { position: 'absolute', width: 170, height: 170, borderRadius: 85 },
  repRingInner: { alignItems: 'center' },
  repLabel: { fontSize: 9, fontWeight: '700', color: Theme.secondary, letterSpacing: 2.5 },
  repCount: { fontSize: 60, fontWeight: '300', color: Theme.primary, letterSpacing: -3 },
  dotRow: { flexDirection: 'row', gap: 3 },
  repDot: {
    width: 4, height: 4, borderRadius: 2,
    backgroundColor: Theme.outlineVariant,
  },
  repDotActive: {
    width: 6, height: 6, borderRadius: 3,
    backgroundColor: Theme.primary,
  },
  actions: { paddingHorizontal: 18, paddingBottom: 16, gap: 9 },
  stopBtn: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
    gap: 8, height: 58, backgroundColor: '#DC2626', borderRadius: 14,
    shadowColor: '#DC2626', shadowOpacity: 0.38, shadowRadius: 10,
    shadowOffset: { width: 0, height: 4 },
  },
  stopText: { fontSize: 14, fontWeight: '800', color: '#fff', letterSpacing: 1.2 },
  pauseBtn: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
    gap: 7, height: 50, backgroundColor: '#fff', borderRadius: 14,
    borderWidth: 1, borderColor: 'rgba(225,226,237,0.8)',
  },
  pauseText: { fontSize: 14, fontWeight: '700', color: Theme.secondary },
  progressBar: {
    height: 5, backgroundColor: 'rgba(225,226,237,0.25)',
  },
  progressFill: {
    height: 5, backgroundColor: Theme.primary,
    shadowColor: Theme.primary, shadowOpacity: 0.4, shadowRadius: 4,
  },
});
