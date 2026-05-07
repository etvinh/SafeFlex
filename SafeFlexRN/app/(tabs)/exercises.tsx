import { useState } from 'react';
import { View, Text, TouchableOpacity, ScrollView, StyleSheet } from 'react-native';
import { router } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Theme } from '../../src/theme';

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

function ExerciseRow({ name, meta }: { name: string; meta: string }) {
  return (
    <View style={styles.exRow}>
      <View style={styles.exRowIcon}>
        <Ionicons name="barbell" size={16} color={Theme.primary} />
      </View>
      <View style={{ flex: 1 }}>
        <Text style={styles.exRowName}>{name}</Text>
        <Text style={styles.exRowMeta}>{meta}</Text>
      </View>
      <TouchableOpacity
        style={styles.exRowBtn}
        onPress={() => router.push('/live-session')}
      >
        <Text style={styles.exRowBtnText}>Start</Text>
      </TouchableOpacity>
    </View>
  );
}

const LIBRARY = [
  { name: 'Hip Abduction', cat: 'Mobility • Lower Body', icon: 'walk' as const },
  { name: 'Scapular Squeeze', cat: 'Posture • Upper Body', icon: 'body' as const },
  { name: 'Bicep Curls', cat: 'Strength • Upper Body', icon: 'barbell' as const },
  { name: 'Quad Extension', cat: 'Strength • Lower Body', icon: 'fitness' as const },
];

export default function ExercisesScreen() {
  const [segment, setSegment] = useState<'prescribed' | 'library'>('prescribed');

  return (
    <View style={styles.container}>
      <TopBar />
      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scroll}>
        {/* Search */}
        <View style={styles.searchBar}>
          <Ionicons name="search" size={15} color={Theme.outline} />
          <Text style={styles.searchText}>Search exercises...</Text>
        </View>

        {/* Segmented control */}
        <View style={styles.segControl}>
          {(['prescribed', 'library'] as const).map((seg) => (
            <TouchableOpacity
              key={seg}
              style={[styles.segBtn, segment === seg && styles.segBtnActive]}
              onPress={() => setSegment(seg)}
            >
              <Text style={[styles.segText, segment === seg && styles.segTextActive]}>
                {seg === 'prescribed' ? 'Prescribed' : 'Library'}
              </Text>
            </TouchableOpacity>
          ))}
        </View>

        {segment === 'prescribed' ? (
          <View style={{ gap: 10 }}>
            <View style={styles.sectionHeader}>
              <Text style={styles.sectionTitle}>Your Program</Text>
              <Text style={styles.sectionCount}>3 Total</Text>
            </View>

            {/* Featured exercise */}
            <View style={styles.featuredCard}>
              <View style={styles.featuredHeader}>
                <View>
                  <Text style={styles.featuredName}>Shoulder Abduction</Text>
                  <Text style={styles.featuredCat}>UPPER BODY • RECOVERY</Text>
                </View>
                <View style={styles.todayBadge}>
                  <Text style={styles.todayBadgeText}>TODAY</Text>
                </View>
              </View>

              <View style={styles.featuredIllustration}>
                <Ionicons name="body" size={50} color={`${Theme.primary}59`} />
              </View>

              <View style={styles.featuredFooter}>
                <View style={styles.setRepRow}>
                  <View>
                    <Text style={styles.setRepLabel}>SETS</Text>
                    <Text style={styles.setRepValue}>3</Text>
                  </View>
                  <View>
                    <Text style={styles.setRepLabel}>REPS</Text>
                    <Text style={styles.setRepValue}>12</Text>
                  </View>
                </View>
                <TouchableOpacity
                  style={styles.startBtn}
                  onPress={() => router.push('/live-session')}
                  activeOpacity={0.8}
                >
                  <Ionicons name="play" size={11} color="#fff" />
                  <Text style={styles.startBtnText}>Start</Text>
                </TouchableOpacity>
              </View>
            </View>

            <ExerciseRow name="Wrist Flexion" meta="2 Sets • 15 Reps" />
            <ExerciseRow name="Neck Stretch" meta="3 Sets • 30s Hold" />
          </View>
        ) : (
          <View>
            <View style={styles.sectionHeader}>
              <Text style={styles.sectionTitle}>AI Recommended</Text>
              <TouchableOpacity>
                <Text style={styles.filterBtn}>Filter</Text>
              </TouchableOpacity>
            </View>
            {LIBRARY.map((item) => (
              <View key={item.name} style={styles.libRow}>
                <View style={styles.libIcon}>
                  <Ionicons name={item.icon} size={18} color={Theme.secondary} />
                </View>
                <View style={{ flex: 1 }}>
                  <Text style={styles.libName}>{item.name}</Text>
                  <Text style={styles.libCat}>{item.cat}</Text>
                </View>
                <Ionicons name="chevron-forward" size={12} color={Theme.outline} />
              </View>
            ))}
          </View>
        )}

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
  searchBar: {
    flexDirection: 'row', alignItems: 'center', gap: 9,
    paddingHorizontal: 14, height: 44, backgroundColor: '#fff',
    borderRadius: 12, borderWidth: 1, borderColor: Theme.outlineVariant,
    shadowColor: '#000', shadowOpacity: 0.04, shadowRadius: 1,
    shadowOffset: { width: 0, height: 1 }, marginBottom: 10,
  },
  searchText: { fontSize: 14, color: Theme.outline },
  segControl: {
    flexDirection: 'row', padding: 3,
    backgroundColor: Theme.surfaceContainer, borderRadius: 10,
    marginBottom: 16,
  },
  segBtn: {
    flex: 1, height: 34, borderRadius: 8,
    alignItems: 'center', justifyContent: 'center',
  },
  segBtnActive: {
    backgroundColor: '#fff',
    shadowColor: '#000', shadowOpacity: 0.07, shadowRadius: 1.5,
    shadowOffset: { width: 0, height: 1 },
  },
  segText: { fontSize: 12, fontWeight: '500', color: Theme.onSurfaceVariant },
  segTextActive: { fontWeight: '700', color: Theme.primary },
  sectionHeader: {
    flexDirection: 'row', justifyContent: 'space-between',
    alignItems: 'center', marginBottom: 10,
  },
  sectionTitle: {
    fontSize: 20, fontWeight: '800', color: Theme.onSurface, letterSpacing: -0.3,
  },
  sectionCount: { fontSize: 11, fontWeight: '700', color: Theme.primary },
  filterBtn: { fontSize: 12, fontWeight: '600', color: Theme.primary },
  featuredCard: {
    backgroundColor: 'rgba(255,255,255,0.72)', borderRadius: 14,
    borderWidth: 1, borderColor: `${Theme.primary}1A`,
    padding: 15, gap: 11,
  },
  featuredHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start' },
  featuredName: { fontSize: 18, fontWeight: '800', color: Theme.onSurface, letterSpacing: -0.3 },
  featuredCat: { fontSize: 9, fontWeight: '600', color: Theme.outline, letterSpacing: 0.9 },
  todayBadge: {
    backgroundColor: `${Theme.primary}17`, borderRadius: 99,
    paddingHorizontal: 10, paddingVertical: 3,
  },
  todayBadgeText: { fontSize: 9, fontWeight: '800', color: Theme.primary },
  featuredIllustration: {
    height: 140, borderRadius: 10,
    backgroundColor: '#EFF6FF', borderWidth: 1,
    borderColor: `${Theme.primary}14`,
    alignItems: 'center', justifyContent: 'center',
  },
  featuredFooter: {
    flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
    paddingTop: 10, borderTopWidth: 1, borderTopColor: 'rgba(195,198,215,0.4)',
  },
  setRepRow: { flexDirection: 'row', gap: 22 },
  setRepLabel: { fontSize: 9, fontWeight: '600', color: Theme.secondary, letterSpacing: 0.5 },
  setRepValue: { fontSize: 22, fontWeight: '800', color: Theme.onSurface, letterSpacing: -0.5 },
  startBtn: {
    flexDirection: 'row', gap: 5, alignItems: 'center',
    backgroundColor: Theme.primary, paddingHorizontal: 18, height: 36,
    borderRadius: 9,
    shadowColor: Theme.primary, shadowOpacity: 0.3, shadowRadius: 5,
    shadowOffset: { width: 0, height: 2 },
  },
  startBtnText: { fontSize: 13, fontWeight: '700', color: '#fff' },
  exRow: {
    flexDirection: 'row', alignItems: 'center', gap: 12,
    paddingHorizontal: 14, height: 72, backgroundColor: '#fff',
    borderRadius: 12, borderWidth: 1, borderColor: 'rgba(195,198,215,0.55)',
    shadowColor: '#000', shadowOpacity: 0.04, shadowRadius: 1,
    shadowOffset: { width: 0, height: 1 },
  },
  exRowIcon: {
    width: 44, height: 44, borderRadius: 10,
    backgroundColor: '#EFF6FF',
    alignItems: 'center', justifyContent: 'center',
  },
  exRowName: { fontSize: 14, fontWeight: '700', color: Theme.onSurface },
  exRowMeta: { fontSize: 11, color: Theme.secondary },
  exRowBtn: {
    paddingHorizontal: 12, height: 30, borderRadius: 8,
    backgroundColor: Theme.surfaceContainer,
    alignItems: 'center', justifyContent: 'center',
  },
  exRowBtnText: { fontSize: 11, fontWeight: '700', color: Theme.primary },
  libRow: {
    flexDirection: 'row', alignItems: 'center', gap: 12,
    paddingHorizontal: 14, height: 68, backgroundColor: '#fff',
    borderRadius: 12, borderWidth: 1, borderColor: 'rgba(195,198,215,0.5)',
    shadowColor: '#000', shadowOpacity: 0.04, shadowRadius: 1,
    shadowOffset: { width: 0, height: 1 }, marginBottom: 8,
  },
  libIcon: {
    width: 44, height: 44, borderRadius: 10,
    backgroundColor: Theme.surfaceLow,
    alignItems: 'center', justifyContent: 'center',
  },
  libName: { fontSize: 14, fontWeight: '600', color: Theme.onSurface },
  libCat: { fontSize: 11, color: Theme.outline },
});
