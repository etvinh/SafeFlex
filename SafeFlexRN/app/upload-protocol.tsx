import { useState, useRef, useEffect } from 'react';
import { View, Text, TouchableOpacity, ScrollView, StyleSheet, Animated } from 'react-native';
import { router } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Theme } from '../src/theme';

function GlassCard({ children, style }: { children: React.ReactNode; style?: any }) {
  return <View style={[styles.glassCard, style]}>{children}</View>;
}

export default function UploadProtocolScreen() {
  const [isScanning, setIsScanning] = useState(false);
  const [isDone, setIsDone] = useState(false);
  const progressAnim = useRef(new Animated.Value(0)).current;
  const [progressDisplay, setProgressDisplay] = useState(0);

  const startScan = () => {
    setIsScanning(true);
    progressAnim.setValue(0);
    setProgressDisplay(0);

    Animated.timing(progressAnim, {
      toValue: 100,
      duration: 3000,
      useNativeDriver: false,
    }).start(() => {
      setIsScanning(false);
      setIsDone(true);
    });

    progressAnim.addListener(({ value }) => {
      setProgressDisplay(Math.round(value));
    });
  };

  useEffect(() => {
    return () => progressAnim.removeAllListeners();
  }, []);

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={styles.doneBtn}>Done</Text>
        </TouchableOpacity>
        <Text style={styles.headerTitle}>TherapyPulse</Text>
        <View style={{ width: 40 }} />
      </View>

      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scroll}>
        <Text style={styles.pageTitle}>Upload Protocol</Text>
        <Text style={styles.pageSub}>
          Digitize your recovery plan with medical-grade precision.
        </Text>

        {/* AI Engine card */}
        <GlassCard>
          <View style={styles.aiRow}>
            <View style={styles.aiIcon}>
              <Ionicons name="document-text" size={18} color={Theme.primary} />
            </View>
            <View style={{ flex: 1 }}>
              <Text style={styles.aiTitle}>AI Processing Engine</Text>
              <Text style={styles.aiDesc}>
                Our clinical AI scans your PDF to identify exercises, frequency, and safety
                precautions — creating a structured, interactive regimen tailored to your doctor's
                orders.
              </Text>
            </View>
          </View>
        </GlassCard>

        {/* Upload zone / Success */}
        {!isDone ? (
          <View style={styles.uploadZone}>
            <View style={styles.uploadIcon}>
              <Ionicons name="document-attach" size={28} color={Theme.primary} />
            </View>
            <Text style={styles.uploadTitle}>Drag and drop your PDF</Text>
            <Text style={styles.uploadSub}>or tap to browse local files</Text>
            <View style={styles.supportBadge}>
              <Text style={styles.supportText}>Supported: PDF (Max 25MB)</Text>
            </View>
          </View>
        ) : (
          <View style={styles.successZone}>
            <View style={styles.successCircle}>
              <Ionicons name="checkmark-circle" size={24} color="#15803D" />
            </View>
            <Text style={styles.successTitle}>Protocol Processed!</Text>
            <Text style={styles.successSub}>
              3 exercises extracted and added to your program.
            </Text>
          </View>
        )}

        {/* HIPAA badge */}
        <View style={styles.hipaaRow}>
          <Ionicons name="shield-checkmark" size={14} color="#15803D" />
          <Text style={styles.hipaaText}>HIPAA Compliant & Encrypted Data Processing</Text>
        </View>

        {/* Action area */}
        {isScanning ? (
          <View style={styles.scanningArea}>
            <View style={styles.progressTrack}>
              <Animated.View
                style={[
                  styles.progressFill,
                  {
                    width: progressAnim.interpolate({
                      inputRange: [0, 100],
                      outputRange: ['0%', '100%'],
                    }),
                  },
                ]}
              />
            </View>
            <Text style={styles.scanningText}>Scanning… {progressDisplay}%</Text>
          </View>
        ) : !isDone ? (
          <View>
            <TouchableOpacity style={styles.scanBtn} onPress={startScan} activeOpacity={0.8}>
              <Ionicons name="sparkles" size={16} color="#fff" />
              <Text style={styles.scanBtnText}>Start Scan</Text>
            </TouchableOpacity>
            <Text style={styles.scanTime}>Scan time: ~15 seconds</Text>
          </View>
        ) : (
          <TouchableOpacity
            style={styles.viewBtn}
            onPress={() => router.back()}
            activeOpacity={0.8}
          >
            <Text style={styles.viewBtnText}>View My Program</Text>
          </TouchableOpacity>
        )}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Theme.surface },
  header: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
    paddingHorizontal: 20, height: 56,
  },
  doneBtn: { fontSize: 16, color: Theme.primary },
  headerTitle: { fontSize: 16, fontWeight: '700', color: Theme.onSurface },
  scroll: { paddingHorizontal: 20, paddingTop: 20, paddingBottom: 32 },
  pageTitle: {
    fontSize: 30, fontWeight: '800', color: Theme.primary, letterSpacing: -0.8,
  },
  pageSub: { fontSize: 15, color: Theme.secondary, marginTop: 4, marginBottom: 18 },
  glassCard: {
    backgroundColor: 'rgba(255,255,255,0.72)', borderRadius: 14,
    borderWidth: 1, borderColor: `${Theme.primary}1A`,
    padding: 15, marginBottom: 16,
    shadowColor: Theme.authAccent, shadowOpacity: 0.04, shadowRadius: 8,
    shadowOffset: { width: 0, height: 4 },
  },
  aiRow: { flexDirection: 'row', gap: 14 },
  aiIcon: {
    width: 44, height: 44, borderRadius: 12,
    backgroundColor: Theme.primaryFixed,
    alignItems: 'center', justifyContent: 'center',
  },
  aiTitle: { fontSize: 16, fontWeight: '700', color: Theme.onSurface, marginBottom: 5 },
  aiDesc: { fontSize: 13, color: Theme.onSurfaceVariant, lineHeight: 19 },
  uploadZone: {
    alignItems: 'center', paddingVertical: 36,
    backgroundColor: 'rgba(219,225,255,0.12)',
    borderRadius: 14, borderWidth: 2, borderStyle: 'dashed',
    borderColor: `${Theme.primary}38`, marginBottom: 16,
  },
  uploadIcon: {
    width: 72, height: 72, borderRadius: 36,
    backgroundColor: `${Theme.primary}14`,
    alignItems: 'center', justifyContent: 'center', marginBottom: 12,
  },
  uploadTitle: { fontSize: 16, fontWeight: '700', color: Theme.primary },
  uploadSub: { fontSize: 13, color: Theme.outline, marginTop: 3 },
  supportBadge: {
    marginTop: 12, paddingHorizontal: 14, paddingVertical: 5,
    backgroundColor: Theme.surfaceContainer, borderRadius: 99,
  },
  supportText: { fontSize: 11, color: Theme.onSurfaceVariant },
  successZone: {
    alignItems: 'center', paddingVertical: 20,
    backgroundColor: 'rgba(240,253,244,0.8)',
    borderRadius: 14, borderWidth: 1, borderColor: '#BBF7D0',
    marginBottom: 16,
  },
  successCircle: {
    width: 56, height: 56, borderRadius: 28,
    backgroundColor: '#F0FDF4', borderWidth: 2, borderColor: '#BBF7D0',
    alignItems: 'center', justifyContent: 'center', marginBottom: 12,
  },
  successTitle: { fontSize: 16, fontWeight: '700', color: '#15803D' },
  successSub: { fontSize: 13, color: '#166534', marginTop: 4 },
  hipaaRow: {
    flexDirection: 'row', gap: 8, alignItems: 'center', marginBottom: 14,
  },
  hipaaText: { fontSize: 12, color: Theme.onSurfaceVariant },
  scanningArea: { gap: 8 },
  progressTrack: {
    height: 6, borderRadius: 3, backgroundColor: Theme.surfaceContainer,
    overflow: 'hidden',
  },
  progressFill: { height: 6, borderRadius: 3, backgroundColor: Theme.primary },
  scanningText: { fontSize: 12, color: Theme.outline, textAlign: 'center' },
  scanBtn: {
    flexDirection: 'row', gap: 8,
    height: 52, borderRadius: 13, backgroundColor: Theme.primary,
    alignItems: 'center', justifyContent: 'center',
    shadowColor: Theme.primary, shadowOpacity: 0.4, shadowRadius: 8,
    shadowOffset: { width: 0, height: 4 },
  },
  scanBtnText: { fontSize: 16, fontWeight: '700', color: '#fff' },
  scanTime: { fontSize: 11, color: Theme.outline, textAlign: 'center', marginTop: 8 },
  viewBtn: {
    height: 52, borderRadius: 13, backgroundColor: '#15803D',
    alignItems: 'center', justifyContent: 'center',
  },
  viewBtnText: { fontSize: 16, fontWeight: '700', color: '#fff' },
});
