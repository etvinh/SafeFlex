import { View, Text, ScrollView, StyleSheet } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Theme } from '../../src/theme';

const HEATMAP = [
  1, 0.2, 1, 1, 0.6, 0.2, 1,
  0.8, 1, 1, 0.2, 1, 0.6, 1,
  1, 0.2, 0.8, 1, 1, 0.4, 1,
  0.6, 1, 1, 0.2, 1, 0.8, 0,
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

function StabilityBar({ label, percent, color }: { label: string; percent: number; color: string }) {
  return (
    <View style={{ gap: 5, marginBottom: 10 }}>
      <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
        <Text style={{ fontSize: 11, color: Theme.onSurface }}>{label}</Text>
        <Text style={{ fontSize: 11, fontWeight: '600', color }}>{percent}%</Text>
      </View>
      <View style={styles.barTrack}>
        <View style={[styles.barFill, { width: `${percent}%`, backgroundColor: color }]} />
      </View>
    </View>
  );
}

export default function InsightsScreen() {
  return (
    <View style={styles.container}>
      <TopBar />
      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scroll}>
        {/* Stats */}
        <View style={styles.statsRow}>
          <GlassCard style={{ flex: 1 }}>
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, marginBottom: 7 }}>
              <Ionicons name="bar-chart" size={14} color={Theme.primary} />
              <Text style={styles.statLabel}>AVG. PERFORMANCE</Text>
            </View>
            <View style={{ flexDirection: 'row', alignItems: 'baseline', gap: 6 }}>
              <Text style={styles.statValue}>94%</Text>
              <Text style={[styles.statSub, { color: Theme.tertiary }]}>+2.4%</Text>
            </View>
          </GlassCard>
          <GlassCard style={{ flex: 1 }}>
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, marginBottom: 7 }}>
              <Ionicons name="git-branch" size={14} color={Theme.primary} />
              <Text style={styles.statLabel}>TOTAL REPS</Text>
            </View>
            <View style={{ flexDirection: 'row', alignItems: 'baseline', gap: 6 }}>
              <Text style={styles.statValue}>1,248</Text>
              <Text style={[styles.statSub, { color: Theme.outline }]}>this month</Text>
            </View>
          </GlassCard>
        </View>

        {/* ROM Chart placeholder */}
        <GlassCard>
          <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginBottom: 12 }}>
            <View>
              <Text style={styles.cardTitle}>Range of Motion</Text>
              <Text style={styles.cardSub}>Progress over the last 14 days</Text>
            </View>
            <Ionicons name="information-circle-outline" size={16} color={Theme.outline} />
          </View>
          <View style={styles.chartPlaceholder}>
            <View style={styles.chartLine} />
            <View style={styles.chartArea} />
            <Text style={styles.chartLabel}>72° → 112°</Text>
          </View>
          <View style={styles.chartXAxis}>
            {['Mon', 'Wed', 'Fri', 'Sun', 'Tue', 'Thu', 'Today'].map((l, i) => (
              <Text
                key={l}
                style={[
                  styles.xLabel,
                  i === 6 && { color: Theme.primary, fontWeight: '700' },
                ]}
              >
                {l}
              </Text>
            ))}
          </View>
        </GlassCard>

        {/* Stability + Adherence */}
        <View style={styles.statsRow}>
          <GlassCard style={{ flex: 1 }}>
            <Text style={styles.cardTitle}>Stability</Text>
            <Text style={[styles.cardSub, { marginBottom: 12 }]}>Balance & control</Text>
            <StabilityBar label="Knee Stability" percent={85} color={Theme.primary} />
            <StabilityBar label="Joint Load" percent={92} color={Theme.tertiary} />
          </GlassCard>

          <GlassCard style={{ flex: 1 }}>
            <Text style={styles.cardTitle}>Adherence</Text>
            <Text style={[styles.cardSub, { marginBottom: 10 }]}>Last 28 days</Text>
            <View style={styles.heatmap}>
              {HEATMAP.map((v, i) => (
                <View
                  key={i}
                  style={[
                    styles.heatCell,
                    {
                      backgroundColor:
                        v > 0.5
                          ? `rgba(0,74,198,${v})`
                          : v > 0
                          ? `rgba(0,74,198,${v + 0.1})`
                          : Theme.surfaceHigh,
                      borderWidth: v === 0 ? 1 : 0,
                      borderColor: 'rgba(195,198,215,0.4)',
                    },
                  ]}
                />
              ))}
            </View>
            <View style={styles.heatLegend}>
              <Text style={styles.heatLegendText}>Less</Text>
              <View style={{ flexDirection: 'row', gap: 3 }}>
                {[0.15, 0.35, 0.65, 1.0].map((op) => (
                  <View
                    key={op}
                    style={{
                      width: 8, height: 8, borderRadius: 2,
                      backgroundColor: `rgba(0,74,198,${op})`,
                    }}
                  />
                ))}
              </View>
              <Text style={styles.heatLegendText}>More</Text>
            </View>
          </GlassCard>
        </View>

        {/* Therapist note */}
        <View style={styles.therapistCard}>
          <View style={styles.therapistIcon}>
            <Ionicons name="document-text" size={16} color={Theme.primary} />
          </View>
          <View style={{ flex: 1 }}>
            <Text style={styles.therapistTitle}>Therapist Recommendation</Text>
            <Text style={styles.therapistQuote}>
              "Great improvement in knee flexion. Focus on slow eccentric movements for the next 48
              hours to manage load."
            </Text>
          </View>
        </View>

        <View style={{ height: 96 }} />
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Theme.surface },
  topBar: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
    paddingHorizontal: 20, height: 64, backgroundColor: 'rgba(255,255,255,0.8)',
  },
  logoRow: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  logoText: { fontSize: 18, fontWeight: '800', color: '#1D4ED8', letterSpacing: -0.5 },
  avatar: {
    width: 32, height: 32, borderRadius: 16,
    backgroundColor: Theme.primaryFixed, borderWidth: 1.5,
    borderColor: Theme.primaryFixedDim,
    alignItems: 'center', justifyContent: 'center',
  },
  avatarText: { fontSize: 11, fontWeight: '800', color: Theme.primary },
  scroll: { paddingHorizontal: 20, paddingTop: 14 },
  glassCard: {
    backgroundColor: 'rgba(255,255,255,0.72)', borderRadius: 14,
    borderWidth: 1, borderColor: 'rgba(255,255,255,0.35)',
    padding: 14, marginBottom: 12,
  },
  statsRow: { flexDirection: 'row', gap: 10, marginBottom: 4 },
  statLabel: {
    fontSize: 9, fontWeight: '600', color: Theme.outline,
    letterSpacing: 0.7,
  },
  statValue: {
    fontSize: 30, fontWeight: '800', color: Theme.primary, letterSpacing: -1,
  },
  statSub: { fontSize: 11, fontWeight: '600' },
  cardTitle: { fontSize: 16, fontWeight: '700', color: Theme.onSurface },
  cardSub: { fontSize: 11, color: Theme.outline },
  chartPlaceholder: {
    height: 72, borderRadius: 8,
    backgroundColor: `${Theme.primary}08`,
    justifyContent: 'center', alignItems: 'center',
    position: 'relative', overflow: 'hidden',
  },
  chartLine: {
    position: 'absolute', left: 0, right: 0, top: '40%',
    height: 2, backgroundColor: Theme.primary, borderRadius: 1,
  },
  chartArea: {
    position: 'absolute', left: 0, right: 0, top: '40%', bottom: 0,
    backgroundColor: `${Theme.primary}0C`,
  },
  chartLabel: {
    fontSize: 12, fontWeight: '700', color: Theme.primary,
  },
  chartXAxis: {
    flexDirection: 'row', justifyContent: 'space-between', marginTop: 6,
  },
  xLabel: { fontSize: 9, color: Theme.outline },
  barTrack: {
    height: 6, borderRadius: 3, backgroundColor: Theme.surfaceContainer,
  },
  barFill: { height: 6, borderRadius: 3 },
  heatmap: {
    flexDirection: 'row', flexWrap: 'wrap', gap: 3,
  },
  heatCell: {
    width: '12.5%', aspectRatio: 1, borderRadius: 2,
    flexBasis: '12%', flexGrow: 0,
  },
  heatLegend: {
    flexDirection: 'row', justifyContent: 'space-between',
    alignItems: 'center', marginTop: 8,
  },
  heatLegendText: { fontSize: 8, color: Theme.outline },
  therapistCard: {
    flexDirection: 'row', gap: 12,
    padding: 15, backgroundColor: 'rgba(219,225,255,0.35)',
    borderRadius: 14, borderWidth: 1, borderColor: `${Theme.primary}1F`,
  },
  therapistIcon: {
    width: 38, height: 38, borderRadius: 10,
    backgroundColor: `${Theme.primary}1A`,
    alignItems: 'center', justifyContent: 'center',
  },
  therapistTitle: { fontSize: 14, fontWeight: '700', color: Theme.primary, marginBottom: 4 },
  therapistQuote: {
    fontSize: 13, fontStyle: 'italic', color: Theme.onSurfaceVariant, lineHeight: 19,
  },
});
