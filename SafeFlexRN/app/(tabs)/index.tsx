import { View, Text, TouchableOpacity, ScrollView, StyleSheet } from 'react-native';
import { router } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Theme } from '../../src/theme';

const DAYS: { label: string; done: boolean; num: number; isToday: boolean }[] = [
  { label: 'Mon', done: true, num: 21, isToday: false },
  { label: 'Tue', done: true, num: 22, isToday: false },
  { label: 'Wed', done: false, num: 23, isToday: true },
  { label: 'Thu', done: false, num: 24, isToday: false },
  { label: 'Fri', done: false, num: 25, isToday: false },
  { label: 'Sat', done: false, num: 26, isToday: false },
  { label: 'Sun', done: false, num: 27, isToday: false },
];

function TopBar() {
  return (
    <View style={styles.topBar}>
      <View style={styles.logoRow}>
        <Ionicons name="menu" size={18} color={Theme.primary} />
        <Text style={styles.logoText}>SafeFlex</Text>
      </View>
      <View style={styles.avatar}>
        <Text style={styles.avatarText}>SJ</Text>
      </View>
    </View>
  );
}

function GlassCard({ children, style }: { children: React.ReactNode; style?: any }) {
  return <View style={[styles.glassCard, style]}>{children}</View>;
}

export default function DashboardScreen() {
  const dateStr = new Date().toLocaleDateString('en-US', {
    weekday: 'long',
    month: 'long',
    day: 'numeric',
  });

  return (
    <View style={styles.container}>
      <TopBar />
      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scroll}>
        {/* Greeting */}
        <Text style={styles.dateLabel}>{dateStr.toUpperCase()}</Text>
        <Text style={styles.greeting}>Hello, Sarah</Text>

        {/* Upload Protocol CTA */}
        <TouchableOpacity
          style={styles.uploadCta}
          onPress={() => router.push('/upload-protocol')}
          activeOpacity={0.7}
        >
          <View style={styles.uploadIcon}>
            <Ionicons name="document-attach" size={18} color={Theme.primary} />
          </View>
          <View style={{ flex: 1 }}>
            <Text style={styles.uploadTitle}>Upload Prescribed Protocol</Text>
            <Text style={styles.uploadSub}>AI creates your exercise regimen automatically</Text>
          </View>
          <Ionicons name="add-circle" size={20} color={Theme.primary} />
        </TouchableOpacity>

        {/* Sensor Status */}
        <GlassCard>
          <View style={styles.sensorRow}>
            <View style={styles.sensorIcon}>
              <Ionicons name="radio" size={18} color={Theme.primary} />
            </View>
            <View style={{ flex: 1 }}>
              <Text style={styles.sensorTitle}>Sensor Status</Text>
              <Text style={styles.sensorSub}>SafeFlex Band v2 Connected</Text>
            </View>
            <View style={styles.activeBadge}>
              <View style={styles.activeDot} />
              <Text style={styles.activeText}>Active</Text>
            </View>
          </View>
        </GlassCard>

        {/* Today's Plan */}
        <GlassCard style={{ padding: 0, overflow: 'hidden' }}>
          <View style={styles.planHero}>
            <Ionicons
              name="body"
              size={50}
              color="rgba(255,255,255,0.18)"
              style={{ position: 'absolute', right: 16, top: 20 }}
            />
            <View style={styles.planBadge}>
              <Text style={styles.planBadgeText}>RECOMMENDED</Text>
            </View>
          </View>
          <View style={{ padding: 15, gap: 10 }}>
            <View style={styles.planHeader}>
              <View>
                <Text style={styles.planTitle}>Today's Plan</Text>
                <Text style={styles.planFocus}>Focus: Shoulder Stability</Text>
              </View>
              <View style={{ alignItems: 'flex-end' }}>
                <Text style={styles.planPercent}>0%</Text>
                <Text style={styles.planComplete}>Complete</Text>
              </View>
            </View>

            <View style={styles.exerciseRow}>
              <View style={styles.exerciseIcon}>
                <Ionicons name="barbell" size={14} color={Theme.primary} />
              </View>
              <View style={{ flex: 1 }}>
                <Text style={styles.exerciseName}>External Rotation</Text>
                <Text style={styles.exerciseMeta}>3 Sets × 12 Reps</Text>
              </View>
              <Ionicons name="chevron-forward" size={12} color={Theme.outline} />
            </View>

            <View style={styles.progressTrack}>
              <View style={styles.progressFill} />
            </View>
          </View>
        </GlassCard>

        {/* Weekly Adherence */}
        <GlassCard>
          <Text style={styles.adherenceTitle}>Weekly Adherence</Text>
          <View style={styles.daysRow}>
            {DAYS.map((day, i) => (
              <View key={i} style={styles.dayCol}>
                <View
                  style={[
                    styles.dayCircle,
                    day.done && styles.dayCircleDone,
                    day.isToday && styles.dayCircleToday,
                    !day.done && !day.isToday && { opacity: 0.45 },
                  ]}
                >
                  {day.done ? (
                    <Ionicons name="checkmark" size={12} color="#fff" />
                  ) : (
                    <Text
                      style={[
                        styles.dayNum,
                        day.isToday && { color: Theme.primary },
                      ]}
                    >
                      {day.num}
                    </Text>
                  )}
                </View>
                <Text
                  style={[
                    styles.dayLabel,
                    day.isToday && { color: Theme.primary, fontWeight: '700' },
                  ]}
                >
                  {day.label.toUpperCase()}
                </Text>
              </View>
            ))}
          </View>
        </GlassCard>

        {/* Stats */}
        <View style={styles.statsRow}>
          <GlassCard style={{ flex: 1 }}>
            <View style={[styles.statAccent, { backgroundColor: Theme.primary }]} />
            <View style={{ padding: 15 }}>
              <Text style={styles.statLabel}>Pain Level</Text>
              <View style={{ flexDirection: 'row', alignItems: 'baseline', gap: 2 }}>
                <Text style={styles.statValue}>2.4</Text>
                <Text style={styles.statSuffix}>/10</Text>
              </View>
              <View style={styles.trendRow}>
                <Ionicons name="arrow-down-forward" size={10} color={Theme.primary} />
                <Text style={[styles.trendText, { color: Theme.primary }]}>-12%</Text>
              </View>
            </View>
          </GlassCard>
          <GlassCard style={{ flex: 1 }}>
            <View style={[styles.statAccent, { backgroundColor: Theme.tertiary }]} />
            <View style={{ padding: 15 }}>
              <Text style={styles.statLabel}>Mobility</Text>
              <Text style={styles.statValue}>78°</Text>
              <View style={styles.trendRow}>
                <Ionicons name="arrow-up-forward" size={10} color={Theme.tertiary} />
                <Text style={[styles.trendText, { color: Theme.tertiary }]}>+5°</Text>
              </View>
            </View>
          </GlassCard>
        </View>

        <View style={{ height: 80 }} />
      </ScrollView>

      {/* FAB */}
      <TouchableOpacity
        style={styles.fab}
        onPress={() => router.push('/live-session')}
        activeOpacity={0.8}
      >
        <Ionicons name="play" size={14} color="#fff" />
        <Text style={styles.fabText}>Start Session</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Theme.surface },
  topBar: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    height: 64,
    backgroundColor: 'rgba(255,255,255,0.8)',
  },
  logoRow: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  logoText: { fontSize: 18, fontWeight: '800', color: '#1D4ED8', letterSpacing: -0.5 },
  avatar: {
    width: 32, height: 32, borderRadius: 16,
    backgroundColor: Theme.primaryFixed,
    borderWidth: 1.5, borderColor: Theme.primaryFixedDim,
    alignItems: 'center', justifyContent: 'center',
  },
  avatarText: { fontSize: 11, fontWeight: '800', color: Theme.primary },
  scroll: { paddingHorizontal: 20, paddingTop: 16 },
  dateLabel: {
    fontSize: 11, fontWeight: '600', color: Theme.secondary,
    letterSpacing: 0.9, marginBottom: 2,
  },
  greeting: {
    fontSize: 30, fontWeight: '800', color: Theme.onSurface,
    letterSpacing: -0.7, marginBottom: 16,
  },
  glassCard: {
    backgroundColor: 'rgba(255,255,255,0.72)',
    borderRadius: 14,
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.35)',
    padding: 15,
    marginBottom: 12,
  },
  uploadCta: {
    flexDirection: 'row', alignItems: 'center', gap: 13,
    padding: 15, backgroundColor: 'rgba(219,225,255,0.3)',
    borderRadius: 14, borderWidth: 2, borderStyle: 'dashed',
    borderColor: 'rgba(0,74,198,0.3)', marginBottom: 12,
  },
  uploadIcon: {
    width: 44, height: 44, borderRadius: 22,
    backgroundColor: 'rgba(0,74,198,0.1)',
    alignItems: 'center', justifyContent: 'center',
  },
  uploadTitle: { fontSize: 13, fontWeight: '700', color: Theme.onSurface },
  uploadSub: { fontSize: 11, color: Theme.secondary },
  sensorRow: { flexDirection: 'row', alignItems: 'center', gap: 13 },
  sensorIcon: {
    width: 44, height: 44, borderRadius: 22,
    backgroundColor: Theme.primaryFixed,
    alignItems: 'center', justifyContent: 'center',
  },
  sensorTitle: { fontSize: 13, fontWeight: '700', color: Theme.onSurface },
  sensorSub: { fontSize: 11, color: Theme.secondary },
  activeBadge: { flexDirection: 'row', alignItems: 'center', gap: 5 },
  activeDot: {
    width: 7, height: 7, borderRadius: 3.5,
    backgroundColor: Theme.success,
    shadowColor: Theme.success, shadowOpacity: 0.7, shadowRadius: 3,
  },
  activeText: { fontSize: 11, fontWeight: '700', color: Theme.primary },
  planHero: {
    height: 128,
    backgroundColor: '#1D4ED8',
    borderTopLeftRadius: 14,
    borderTopRightRadius: 14,
    justifyContent: 'flex-end',
  },
  planBadge: {
    backgroundColor: Theme.primary,
    borderRadius: 99,
    paddingHorizontal: 10,
    paddingVertical: 3,
    alignSelf: 'flex-start',
    margin: 14,
  },
  planBadgeText: { fontSize: 9, fontWeight: '800', color: '#fff', letterSpacing: 0.8 },
  planHeader: { flexDirection: 'row', justifyContent: 'space-between' },
  planTitle: { fontSize: 17, fontWeight: '700', color: Theme.onSurface },
  planFocus: { fontSize: 12, color: Theme.secondary },
  planPercent: {
    fontSize: 26, fontWeight: '800', color: Theme.primary, letterSpacing: -1,
  },
  planComplete: { fontSize: 9, color: Theme.secondary },
  exerciseRow: {
    flexDirection: 'row', alignItems: 'center', gap: 11,
    padding: 13, backgroundColor: Theme.surfaceLow,
    borderRadius: 10, borderWidth: 1,
    borderColor: 'rgba(195,198,215,0.3)',
  },
  exerciseIcon: {
    width: 34, height: 34, borderRadius: 8,
    backgroundColor: '#fff',
    alignItems: 'center', justifyContent: 'center',
    shadowColor: '#000', shadowOpacity: 0.06, shadowRadius: 1.5, shadowOffset: { width: 0, height: 1 },
  },
  exerciseName: { fontSize: 13, fontWeight: '600', color: Theme.onSurface },
  exerciseMeta: { fontSize: 11, color: Theme.secondary },
  progressTrack: {
    height: 4, borderRadius: 2,
    backgroundColor: Theme.surfaceContainer,
  },
  progressFill: { width: 0, height: 4, borderRadius: 2, backgroundColor: Theme.primary },
  adherenceTitle: {
    fontSize: 14, fontWeight: '700', color: Theme.onSurface, marginBottom: 12,
  },
  daysRow: { flexDirection: 'row' },
  dayCol: { flex: 1, alignItems: 'center', gap: 4 },
  dayCircle: {
    width: 36, height: 36, borderRadius: 18,
    backgroundColor: Theme.surfaceContainer,
    alignItems: 'center', justifyContent: 'center',
  },
  dayCircleDone: {
    backgroundColor: Theme.primary,
    shadowColor: Theme.primary, shadowOpacity: 0.28, shadowRadius: 3,
    shadowOffset: { width: 0, height: 2 },
  },
  dayCircleToday: {
    backgroundColor: Theme.primaryFixed,
    borderWidth: 2, borderColor: Theme.primary,
  },
  dayNum: { fontSize: 11, fontWeight: '600', color: Theme.outline },
  dayLabel: { fontSize: 9, fontWeight: '500', color: Theme.secondary },
  statsRow: { flexDirection: 'row', gap: 10 },
  statAccent: {
    position: 'absolute', left: 0, top: 0, bottom: 0, width: 4,
    borderTopLeftRadius: 14, borderBottomLeftRadius: 14,
  },
  statLabel: { fontSize: 11, color: Theme.secondary },
  statValue: { fontSize: 22, fontWeight: '700', color: Theme.onSurface },
  statSuffix: { fontSize: 11, color: Theme.secondary },
  trendRow: { flexDirection: 'row', alignItems: 'center', gap: 3, marginTop: 2 },
  trendText: { fontSize: 10, fontWeight: '700' },
  fab: {
    position: 'absolute', bottom: 90, right: 16,
    flexDirection: 'row', alignItems: 'center', gap: 7,
    backgroundColor: Theme.primary,
    paddingHorizontal: 18, paddingVertical: 12,
    borderRadius: 99,
    shadowColor: Theme.primary, shadowOpacity: 0.45, shadowRadius: 10,
    shadowOffset: { width: 0, height: 4 },
  },
  fabText: { fontSize: 13, fontWeight: '700', color: '#fff', letterSpacing: -0.2 },
});
