import { useState } from 'react';
import { View, Text, TouchableOpacity, ScrollView, Switch, StyleSheet } from 'react-native';
import { router } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Theme } from '../src/theme';

function GlassCard({ children, style }: { children: React.ReactNode; style?: any }) {
  return <View style={[styles.glassCard, style]}>{children}</View>;
}

function BatteryRing({ percent }: { percent: number }) {
  return (
    <View style={styles.batteryRing}>
      <Text style={styles.batteryPercent}>{percent}%</Text>
      <Ionicons name="flash" size={8} color={Theme.primary} />
    </View>
  );
}

function DeviceActionRow({ icon, title, subtitle, badge }: {
  icon: keyof typeof Ionicons.glyphMap; title: string; subtitle: string; badge?: string;
}) {
  return (
    <View style={styles.actionRow}>
      <View style={styles.actionIcon}>
        <Ionicons name={icon} size={16} color={Theme.primary} />
      </View>
      <View style={{ flex: 1 }}>
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 7 }}>
          <Text style={styles.actionTitle}>{title}</Text>
          {badge && (
            <View style={styles.badge}>
              <Text style={styles.badgeText}>{badge}</Text>
            </View>
          )}
        </View>
        <Text style={styles.actionSub}>{subtitle}</Text>
      </View>
      <Ionicons name="chevron-forward" size={12} color={Theme.outline} />
    </View>
  );
}

export default function DeviceSettingsScreen() {
  const [autoSync, setAutoSync] = useState(true);

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={styles.doneBtn}>Done</Text>
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Device Settings</Text>
        <View style={{ width: 40 }} />
      </View>

      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scroll}>
        {/* Device hero */}
        <GlassCard>
          <View style={styles.heroRow}>
            <View>
              <View style={styles.activeBadge}>
                <View style={styles.activeDot} />
                <Text style={styles.activeText}>Active</Text>
              </View>
              <Text style={styles.deviceName}>SafeFlex Band v2</Text>
              <Text style={styles.deviceSub}>Bluetooth LE Connected</Text>
            </View>
            <BatteryRing percent={84} />
          </View>
        </GlassCard>

        {/* Device Actions */}
        <Text style={styles.sectionLabel}>DEVICE ACTIONS</Text>
        <GlassCard style={{ padding: 0 }}>
          <DeviceActionRow icon="git-branch" title="Recalibrate Sensors" subtitle="Adjust accuracy for therapy" />
          <View style={styles.divider} />
          <DeviceActionRow icon="analytics" title="Firmware Update" subtitle="v2.4.1 Stable available" badge="NEW" />
        </GlassCard>

        {/* Connectivity */}
        <Text style={styles.sectionLabel}>CONNECTIVITY</Text>
        <GlassCard style={{ padding: 0 }}>
          <View style={styles.actionRow}>
            <View style={styles.actionIcon}>
              <Ionicons name="sync" size={16} color={Theme.primary} />
            </View>
            <View style={{ flex: 1 }}>
              <Text style={styles.actionTitle}>Auto-Sync Data</Text>
              <Text style={styles.actionSub}>Real-time clinical updates</Text>
            </View>
            <Switch
              value={autoSync}
              onValueChange={setAutoSync}
              trackColor={{ true: Theme.primary, false: '#ccc' }}
            />
          </View>
          <View style={styles.divider} />
          <View style={styles.actionRow}>
            <View style={[styles.actionIcon, { backgroundColor: 'rgba(186,26,26,0.08)' }]}>
              <Ionicons name="link" size={16} color={Theme.error} />
            </View>
            <View style={{ flex: 1 }}>
              <Text style={[styles.actionTitle, { color: Theme.error }]}>Disconnect Device</Text>
              <Text style={[styles.actionSub, { color: 'rgba(186,26,26,0.6)' }]}>
                Unpair from this smartphone
              </Text>
            </View>
            <Ionicons name="chevron-forward" size={12} color="rgba(186,26,26,0.35)" />
          </View>
        </GlassCard>

        {/* Technical Details */}
        <Text style={styles.sectionLabel}>TECHNICAL DETAILS</Text>
        <View style={styles.techRow}>
          <View style={styles.techCard}>
            <Text style={styles.techLabel}>Serial Number</Text>
            <Text style={styles.techValue}>SF-2024-9982-A</Text>
          </View>
          <View style={styles.techCard}>
            <Text style={styles.techLabel}>Hardware Rev</Text>
            <Text style={styles.techValue}>REV_E_04</Text>
          </View>
        </View>
        <View style={styles.fdaCard}>
          <View>
            <Text style={styles.techLabel}>FDA Compliance</Text>
            <Text style={styles.fdaValue}>Class II Therapeutic Device</Text>
          </View>
          <Ionicons name="checkmark-circle" size={22} color={`${Theme.primary}59`} />
        </View>
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
  scroll: { paddingHorizontal: 20, paddingTop: 16, paddingBottom: 32 },
  glassCard: {
    backgroundColor: 'rgba(255,255,255,0.72)', borderRadius: 14,
    borderWidth: 1, borderColor: 'rgba(255,255,255,0.35)',
    padding: 16, marginBottom: 18,
  },
  heroRow: {
    flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
  },
  activeBadge: {
    flexDirection: 'row', alignItems: 'center', gap: 5,
    paddingHorizontal: 8, paddingVertical: 2, backgroundColor: '#F0FDF4',
    borderRadius: 99, borderWidth: 1, borderColor: '#BBF7D0',
    alignSelf: 'flex-start', marginBottom: 6,
  },
  activeDot: { width: 6, height: 6, borderRadius: 3, backgroundColor: '#16A34A' },
  activeText: { fontSize: 10, fontWeight: '700', color: '#15803D' },
  deviceName: { fontSize: 18, fontWeight: '700', color: Theme.onSurface, letterSpacing: -0.3 },
  deviceSub: { fontSize: 11, color: Theme.secondary },
  batteryRing: {
    width: 52, height: 52, borderRadius: 26,
    borderWidth: 4, borderColor: Theme.primary,
    alignItems: 'center', justifyContent: 'center',
  },
  batteryPercent: { fontSize: 12, fontWeight: '800', color: Theme.onSurface },
  sectionLabel: {
    fontSize: 11, fontWeight: '600', color: Theme.onSurfaceVariant,
    letterSpacing: 0.6, paddingLeft: 2, marginBottom: 8,
  },
  actionRow: {
    flexDirection: 'row', alignItems: 'center', gap: 14,
    paddingHorizontal: 16, paddingVertical: 13,
  },
  actionIcon: {
    width: 38, height: 38, borderRadius: 10,
    backgroundColor: `${Theme.primary}14`,
    alignItems: 'center', justifyContent: 'center',
  },
  actionTitle: { fontSize: 15, color: Theme.onSurface },
  actionSub: { fontSize: 11, color: Theme.secondary },
  badge: {
    backgroundColor: Theme.primaryContainer,
    borderRadius: 4, paddingHorizontal: 5, paddingVertical: 2,
  },
  badgeText: { fontSize: 9, fontWeight: '800', color: '#fff' },
  divider: { height: 1, backgroundColor: '#eee', marginHorizontal: 16 },
  techRow: { flexDirection: 'row', gap: 10, marginBottom: 10 },
  techCard: {
    flex: 1, padding: 13, backgroundColor: Theme.surfaceLow,
    borderRadius: 12, borderWidth: 1, borderColor: Theme.surfaceHighest,
  },
  techLabel: { fontSize: 11, color: Theme.onSurfaceVariant },
  techValue: {
    fontSize: 13, fontWeight: '700', color: Theme.onSurface,
    fontVariant: ['tabular-nums'], marginTop: 4,
  },
  fdaCard: {
    flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
    padding: 13, backgroundColor: Theme.surfaceLow,
    borderRadius: 12, borderWidth: 1, borderColor: Theme.surfaceHighest,
    marginBottom: 18,
  },
  fdaValue: { fontSize: 14, fontWeight: '600', color: Theme.onSurface, marginTop: 4 },
});
