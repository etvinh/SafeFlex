import { useState } from 'react';
import { View, Text, TouchableOpacity, ScrollView, Switch, StyleSheet } from 'react-native';
import { router } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Theme } from '../../src/theme';
import { useAppState } from '../../src/store';

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

function ProfileRow({
  icon, title, iconBg, iconColor, onPress,
}: {
  icon: keyof typeof Ionicons.glyphMap;
  title: string;
  iconBg?: string;
  iconColor?: string;
  onPress: () => void;
}) {
  return (
    <TouchableOpacity style={styles.profileRow} onPress={onPress} activeOpacity={0.7}>
      <View style={[styles.profileRowIcon, { backgroundColor: iconBg || 'rgba(219,225,255,0.5)' }]}>
        <Ionicons name={icon} size={16} color={iconColor || Theme.primary} />
      </View>
      <Text style={styles.profileRowTitle}>{title}</Text>
      <Ionicons name="chevron-forward" size={12} color={Theme.outline} />
    </TouchableOpacity>
  );
}

export default function ProfileScreen() {
  const { setAuthenticated } = useAppState();
  const [healthKitEnabled, setHealthKitEnabled] = useState(true);

  return (
    <View style={styles.container}>
      <TopBar />
      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scroll}>
        {/* User header */}
        <View style={styles.userHeader}>
          <View style={styles.userAvatarWrap}>
            <View style={styles.userAvatar}>
              <Text style={styles.userAvatarText}>SJ</Text>
            </View>
            <View style={styles.editBadge}>
              <Ionicons name="pencil" size={10} color="#fff" />
            </View>
          </View>
          <View>
            <Text style={styles.userName}>Sarah Jenkins</Text>
            <Text style={styles.userId}>Patient ID: SF-8829-X</Text>
          </View>
        </View>

        {/* Account Settings */}
        <Text style={styles.sectionLabel}>ACCOUNT SETTINGS</Text>
        <View style={styles.settingsGroup}>
          <ProfileRow icon="person" title="Personal Information" onPress={() => router.push('/personal-info')} />
          <View style={styles.divider} />
          <ProfileRow icon="notifications" title="Notification Preferences" onPress={() => {}} />
        </View>

        {/* Health & Privacy */}
        <Text style={styles.sectionLabel}>HEALTH & PRIVACY</Text>
        <View style={styles.settingsGroup}>
          <View style={styles.profileRow}>
            <View style={[styles.profileRowIcon, { backgroundColor: 'rgba(255,219,205,0.5)' }]}>
              <Ionicons name="heart" size={16} color={Theme.tertiary} />
            </View>
            <View style={{ flex: 1 }}>
              <Text style={styles.profileRowTitle}>Apple HealthKit Sync</Text>
              <Text style={styles.profileRowSub}>Sync your recovery metrics</Text>
            </View>
            <Switch
              value={healthKitEnabled}
              onValueChange={setHealthKitEnabled}
              trackColor={{ true: Theme.primary, false: '#ccc' }}
            />
          </View>
          <View style={styles.divider} />
          <ProfileRow
            icon="lock-closed"
            title="Privacy & Data Sharing"
            iconBg="rgba(255,219,205,0.5)"
            iconColor={Theme.tertiary}
            onPress={() => {}}
          />
        </View>

        {/* Device Settings */}
        <Text style={styles.sectionLabel}>DEVICE SETTINGS</Text>
        <View style={styles.deviceCard}>
          <View style={styles.deviceRow}>
            <View style={styles.deviceIcon}>
              <Ionicons name="watch" size={20} color={Theme.primary} />
            </View>
            <View style={{ flex: 1 }}>
              <Text style={styles.deviceName}>SafeFlex Band v2</Text>
              <Text style={styles.deviceStatus}>Connected • 84% Battery</Text>
            </View>
            <TouchableOpacity
              style={styles.manageBtn}
              onPress={() => router.push('/device-settings')}
            >
              <Text style={styles.manageBtnText}>Manage</Text>
            </TouchableOpacity>
          </View>
          <View style={styles.syncRow}>
            <Ionicons name="information-circle-outline" size={11} color={Theme.outline} />
            <Text style={styles.syncText}>Last synchronized: Today at 9:41 AM</Text>
          </View>
        </View>

        {/* Care Team */}
        <Text style={styles.sectionLabel}>CARE TEAM</Text>
        <View style={styles.careCard}>
          <View style={styles.careAvatar}>
            <Text style={styles.careAvatarText}>MC</Text>
          </View>
          <View style={{ flex: 1 }}>
            <Text style={styles.careName}>Dr. Michael Chen</Text>
            <Text style={styles.careRole}>Lead Physical Therapist</Text>
          </View>
          <View style={{ flexDirection: 'row', gap: 8 }}>
            {(['chatbubble', 'call'] as const).map((icon) => (
              <View key={icon} style={styles.careAction}>
                <Ionicons name={icon} size={14} color={Theme.primary} />
              </View>
            ))}
          </View>
        </View>

        {/* Sign Out */}
        <TouchableOpacity
          style={styles.signOutBtn}
          onPress={() => setAuthenticated(false)}
          activeOpacity={0.7}
        >
          <Text style={styles.signOutText}>Sign Out</Text>
        </TouchableOpacity>

        <Text style={styles.versionText}>SafeFlex App v4.2.1-stable</Text>

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
  scroll: { paddingHorizontal: 20, paddingTop: 16 },
  userHeader: {
    flexDirection: 'row', alignItems: 'center', gap: 14, marginBottom: 18,
  },
  userAvatarWrap: { position: 'relative' },
  userAvatar: {
    width: 72, height: 72, borderRadius: 36,
    backgroundColor: '#DBEAFE', borderWidth: 2, borderColor: Theme.primary,
    alignItems: 'center', justifyContent: 'center',
  },
  userAvatarText: { fontSize: 26, fontWeight: '800', color: Theme.primary },
  editBadge: {
    position: 'absolute', right: -2, bottom: -2,
    width: 22, height: 22, borderRadius: 11,
    backgroundColor: Theme.primary, borderWidth: 2, borderColor: '#fff',
    alignItems: 'center', justifyContent: 'center',
  },
  userName: { fontSize: 24, fontWeight: '700', color: Theme.onSurface, letterSpacing: -0.4 },
  userId: { fontSize: 12, color: Theme.secondary },
  sectionLabel: {
    fontSize: 11, fontWeight: '600', color: Theme.onSurfaceVariant,
    letterSpacing: 0.6, paddingLeft: 2, marginBottom: 8,
  },
  settingsGroup: {
    backgroundColor: Theme.surfaceLow, borderRadius: 14,
    borderWidth: 1, borderColor: 'rgba(195,198,215,0.3)',
    marginBottom: 18,
  },
  profileRow: {
    flexDirection: 'row', alignItems: 'center', gap: 14,
    paddingHorizontal: 16, paddingVertical: 14,
  },
  profileRowIcon: {
    width: 38, height: 38, borderRadius: 10,
    alignItems: 'center', justifyContent: 'center',
  },
  profileRowTitle: { flex: 1, fontSize: 15, color: Theme.onSurface },
  profileRowSub: { fontSize: 11, color: Theme.secondary },
  divider: { height: 1, backgroundColor: '#ddd', marginHorizontal: 16 },
  deviceCard: {
    padding: 16, backgroundColor: Theme.surfaceLow, borderRadius: 14,
    borderWidth: 1, borderColor: 'rgba(195,198,215,0.3)', marginBottom: 18,
  },
  deviceRow: { flexDirection: 'row', alignItems: 'center', gap: 12, marginBottom: 10 },
  deviceIcon: {
    width: 44, height: 44, borderRadius: 22,
    backgroundColor: Theme.surfaceHighest,
    alignItems: 'center', justifyContent: 'center',
  },
  deviceName: { fontSize: 14, fontWeight: '700', color: Theme.onSurface },
  deviceStatus: { fontSize: 11, fontWeight: '600', color: Theme.primary },
  manageBtn: {
    paddingHorizontal: 12, height: 32, borderRadius: 8,
    backgroundColor: Theme.surfaceContainer,
    borderWidth: 1, borderColor: `${Theme.primary}2E`,
    alignItems: 'center', justifyContent: 'center',
  },
  manageBtnText: { fontSize: 12, fontWeight: '600', color: Theme.primary },
  syncRow: {
    flexDirection: 'row', gap: 7, alignItems: 'center',
    paddingHorizontal: 10, paddingVertical: 8,
    backgroundColor: 'rgba(255,255,255,0.55)', borderRadius: 8,
  },
  syncText: { fontSize: 10, color: Theme.secondary },
  careCard: {
    flexDirection: 'row', alignItems: 'center', gap: 12,
    padding: 16, backgroundColor: Theme.surfaceLow, borderRadius: 14,
    borderWidth: 1, borderColor: 'rgba(195,198,215,0.3)', marginBottom: 18,
  },
  careAvatar: {
    width: 44, height: 44, borderRadius: 22,
    backgroundColor: '#DBEAFE', borderWidth: 1,
    borderColor: 'rgba(195,198,215,0.4)',
    alignItems: 'center', justifyContent: 'center',
  },
  careAvatarText: { fontSize: 16, fontWeight: '800', color: Theme.primary },
  careName: { fontSize: 14, fontWeight: '700', color: Theme.onSurface },
  careRole: { fontSize: 11, color: Theme.secondary },
  careAction: {
    width: 38, height: 38, borderRadius: 19,
    backgroundColor: 'rgba(219,225,255,0.5)',
    alignItems: 'center', justifyContent: 'center',
  },
  signOutBtn: {
    height: 50, borderRadius: 12,
    backgroundColor: '#fff', borderWidth: 1,
    borderColor: 'rgba(186,26,26,0.2)',
    alignItems: 'center', justifyContent: 'center',
    marginBottom: 12,
  },
  signOutText: { fontSize: 16, fontWeight: '600', color: Theme.error },
  versionText: { fontSize: 10, color: Theme.outline, textAlign: 'center' },
});
