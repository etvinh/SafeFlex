import { useState } from 'react';
import {
  View, Text, TouchableOpacity, ScrollView, Modal, StyleSheet,
} from 'react-native';
import { router } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Theme } from '../src/theme';

const METRICS = [
  { label: 'Total Reps', value: '36', sub: '3 sets completed', color: Theme.primary, bg: '#EFF6FF' },
  { label: 'Avg. ROM', value: '112°', sub: '+8° improvement', color: '#15803D', bg: '#F0FDF4' },
  { label: 'Stability', value: '94%', sub: 'High precision', color: '#15803D', bg: '#F0FDF4' },
  { label: 'Pain Delta', value: '−2.5', sub: 'Decreased intensity', color: '#B45309', bg: '#FFFBEB' },
];

const PROVIDERS = ['Dr. Emily Chen (PT)', 'Dr. Marcus Williams', 'Memorial PT Clinic'];

function ChartCard({
  title, badge, badgeColor, badgeBg, yLow, yHigh, lineColor,
}: {
  title: string; badge: string; badgeColor: string; badgeBg: string;
  yLow: string; yHigh: string; lineColor: string;
}) {
  return (
    <View style={styles.chartCard}>
      <View style={styles.chartHeader}>
        <Text style={styles.chartTitle}>{title}</Text>
        <View style={[styles.chartBadge, { backgroundColor: badgeBg }]}>
          <Text style={[styles.chartBadgeText, { color: badgeColor }]}>{badge}</Text>
        </View>
      </View>
      <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginBottom: 3 }}>
        {['Rep 1', 'Rep 4', 'Rep 8', 'Rep 12'].map((l) => (
          <Text key={l} style={styles.repLabel}>{l}</Text>
        ))}
      </View>
      <View style={[styles.chartArea, { borderColor: lineColor }]}>
        <View style={[styles.chartLine, { backgroundColor: lineColor }]} />
      </View>
      <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginTop: 3 }}>
        <Text style={styles.yLabel}>{yLow}</Text>
        <Text style={styles.yLabel}>{yHigh}</Text>
      </View>
    </View>
  );
}

export default function SessionResultsScreen() {
  const [showShare, setShowShare] = useState(false);
  const [sent, setSent] = useState(false);
  const dateStr = new Date().toLocaleDateString('en-US', {
    month: 'short', day: 'numeric', year: 'numeric',
  });

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
        <View style={styles.completeBadge}>
          <Ionicons name="checkmark" size={8} color="#15803D" />
          <Text style={styles.completeText}>SESSION COMPLETE</Text>
        </View>
      </View>

      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scroll}>
        <Text style={styles.pageTitle}>Session Results</Text>
        <Text style={styles.pageSub}>Shoulder Abduction • {dateStr}</Text>

        {/* Metrics grid */}
        <View style={styles.metricsGrid}>
          {METRICS.map((m) => (
            <View key={m.label} style={[styles.metricCard, { backgroundColor: m.bg }]}>
              <Text style={styles.metricLabel}>{m.label.toUpperCase()}</Text>
              <Text style={[styles.metricValue, { color: m.color }]}>{m.value}</Text>
              <Text style={styles.metricSub}>{m.sub}</Text>
            </View>
          ))}
        </View>

        <ChartCard
          title="Range of Motion (ROM)"
          badge="Peak: 118°"
          badgeColor={Theme.primary}
          badgeBg="#EFF6FF"
          lineColor={Theme.primary}
          yLow="78°"
          yHigh="118°"
        />
        <ChartCard
          title="Stability Score"
          badge="Target: >90%"
          badgeColor="#15803D"
          badgeBg="#F0FDF4"
          lineColor="#16A34A"
          yLow="75%"
          yHigh="96%"
        />

        {/* Actions */}
        <TouchableOpacity
          style={styles.shareBtn}
          onPress={() => setShowShare(true)}
          activeOpacity={0.8}
        >
          <Ionicons name="share-outline" size={13} color="#fff" />
          <Text style={styles.shareBtnText}>Share with PT</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.doneBtn}
          onPress={() => router.replace('/(tabs)')}
          activeOpacity={0.7}
        >
          <Text style={styles.doneBtnText}>Done</Text>
        </TouchableOpacity>
      </ScrollView>

      {/* Share modal */}
      <Modal visible={showShare} transparent animationType="slide">
        <View style={styles.modalOverlay}>
          <View style={styles.modalSheet}>
            <View style={styles.modalHandle} />
            {!sent ? (
              <>
                <Text style={styles.modalTitle}>Share Results</Text>
                <Text style={styles.modalSub}>
                  Select your provider to receive this session report.
                </Text>
                {PROVIDERS.map((p) => (
                  <TouchableOpacity
                    key={p}
                    style={styles.providerRow}
                    onPress={() => setSent(true)}
                  >
                    <View style={styles.providerAvatar}>
                      <Text style={styles.providerInitial}>{p.charAt(4)}</Text>
                    </View>
                    <Text style={styles.providerName}>{p}</Text>
                    <Ionicons name="chevron-forward" size={10} color={Theme.outline} />
                  </TouchableOpacity>
                ))}
                <TouchableOpacity onPress={() => setShowShare(false)}>
                  <Text style={styles.cancelText}>Cancel</Text>
                </TouchableOpacity>
              </>
            ) : (
              <View style={styles.sentView}>
                <View style={styles.sentCircle}>
                  <Ionicons name="checkmark" size={22} color={Theme.success} />
                </View>
                <Text style={styles.sentTitle}>Report Sent!</Text>
                <Text style={styles.sentSub}>
                  Your PT will receive your session results shortly.
                </Text>
                <TouchableOpacity
                  style={styles.sentDoneBtn}
                  onPress={() => {
                    setShowShare(false);
                    setSent(false);
                  }}
                >
                  <Text style={styles.sentDoneText}>Done</Text>
                </TouchableOpacity>
              </View>
            )}
          </View>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Theme.surface },
  appBar: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
    paddingHorizontal: 18, height: 64, backgroundColor: 'rgba(255,255,255,0.82)',
  },
  appBarLeft: { flexDirection: 'row', alignItems: 'center', gap: 9 },
  sjCircle: {
    width: 28, height: 28, borderRadius: 14,
    backgroundColor: Theme.primary,
    alignItems: 'center', justifyContent: 'center',
  },
  sjText: { fontSize: 10, fontWeight: '800', color: '#fff' },
  appBarTitle: { fontSize: 17, fontWeight: '800', color: Theme.primary, letterSpacing: -0.4 },
  completeBadge: {
    flexDirection: 'row', alignItems: 'center', gap: 5,
    paddingHorizontal: 9, height: 22, borderRadius: 11,
    backgroundColor: '#F0FDF4', borderWidth: 1, borderColor: '#BBF7D0',
  },
  completeText: { fontSize: 9, fontWeight: '800', color: '#15803D', letterSpacing: 0.8 },
  scroll: { paddingHorizontal: 18, paddingTop: 18, paddingBottom: 24 },
  pageTitle: {
    fontSize: 22, fontWeight: '800', color: Theme.onSurface, letterSpacing: -0.5,
  },
  pageSub: { fontSize: 13, color: Theme.secondary, marginTop: 3, marginBottom: 16 },
  metricsGrid: {
    flexDirection: 'row', flexWrap: 'wrap', gap: 8, marginBottom: 16,
  },
  metricCard: {
    width: '48%', flexGrow: 1, padding: 13, borderRadius: 13,
  },
  metricLabel: {
    fontSize: 9, fontWeight: '700', color: Theme.secondary,
    letterSpacing: 0.6, marginBottom: 3,
  },
  metricValue: { fontSize: 26, fontWeight: '800', letterSpacing: -0.8 },
  metricSub: { fontSize: 10, color: Theme.secondary, marginTop: 1 },
  chartCard: {
    padding: 13, backgroundColor: '#fff', borderRadius: 13,
    borderWidth: 1, borderColor: 'rgba(195,198,215,0.5)',
    marginBottom: 10,
  },
  chartHeader: {
    flexDirection: 'row', justifyContent: 'space-between',
    alignItems: 'center', marginBottom: 9,
  },
  chartTitle: { fontSize: 13, fontWeight: '700', color: Theme.onSurface },
  chartBadge: {
    paddingHorizontal: 8, height: 20, borderRadius: 10,
    justifyContent: 'center',
  },
  chartBadgeText: { fontSize: 10, fontWeight: '700' },
  repLabel: { fontSize: 8, color: Theme.outline },
  chartArea: {
    height: 68, borderRadius: 8, borderWidth: 1,
    backgroundColor: 'rgba(0,74,198,0.03)',
    justifyContent: 'center', overflow: 'hidden',
  },
  chartLine: {
    height: 2, borderRadius: 1, marginHorizontal: 8,
  },
  yLabel: { fontSize: 8, color: Theme.outline },
  shareBtn: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
    gap: 8, height: 52, backgroundColor: Theme.primary, borderRadius: 12,
    shadowColor: Theme.primary, shadowOpacity: 0.3, shadowRadius: 6,
    shadowOffset: { width: 0, height: 2 }, marginTop: 8,
  },
  shareBtnText: { fontSize: 15, fontWeight: '700', color: '#fff' },
  doneBtn: {
    height: 48, backgroundColor: '#fff', borderRadius: 12,
    borderWidth: 1, borderColor: `${Theme.primary}38`,
    alignItems: 'center', justifyContent: 'center', marginTop: 9,
  },
  doneBtnText: { fontSize: 15, fontWeight: '700', color: Theme.primary },
  modalOverlay: {
    flex: 1, backgroundColor: 'rgba(0,0,0,0.4)', justifyContent: 'flex-end',
  },
  modalSheet: {
    backgroundColor: '#fff', borderTopLeftRadius: 20, borderTopRightRadius: 20,
    paddingHorizontal: 18, paddingBottom: 40,
  },
  modalHandle: {
    width: 34, height: 4, borderRadius: 2,
    backgroundColor: Theme.outlineVariant,
    alignSelf: 'center', marginTop: 10, marginBottom: 16,
  },
  modalTitle: { fontSize: 17, fontWeight: '800', color: Theme.onSurface },
  modalSub: { fontSize: 12, color: Theme.secondary, marginTop: 3, marginBottom: 14 },
  providerRow: {
    flexDirection: 'row', alignItems: 'center', gap: 11,
    paddingHorizontal: 14, height: 52, backgroundColor: '#F8FAFF',
    borderRadius: 13, borderWidth: 1, borderColor: `${Theme.primary}1A`,
    marginBottom: 8,
  },
  providerAvatar: {
    width: 34, height: 34, borderRadius: 17,
    backgroundColor: '#DBEAFE',
    alignItems: 'center', justifyContent: 'center',
  },
  providerInitial: { fontSize: 13, fontWeight: '700', color: Theme.primary },
  providerName: { flex: 1, fontSize: 13, fontWeight: '600', color: Theme.onSurface },
  cancelText: {
    fontSize: 14, color: Theme.secondary, textAlign: 'center', marginTop: 4,
  },
  sentView: { alignItems: 'center', paddingTop: 16 },
  sentCircle: {
    width: 58, height: 58, borderRadius: 29,
    backgroundColor: '#F0FDF4', borderWidth: 2, borderColor: '#BBF7D0',
    alignItems: 'center', justifyContent: 'center', marginBottom: 12,
  },
  sentTitle: { fontSize: 18, fontWeight: '800', color: Theme.onSurface, marginBottom: 5 },
  sentSub: { fontSize: 12, color: Theme.secondary, textAlign: 'center', lineHeight: 18 },
  sentDoneBtn: {
    marginTop: 20, paddingHorizontal: 32, height: 46,
    backgroundColor: Theme.primary, borderRadius: 12,
    alignItems: 'center', justifyContent: 'center',
  },
  sentDoneText: { fontSize: 15, fontWeight: '700', color: '#fff' },
});
