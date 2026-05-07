import { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, ScrollView, StyleSheet } from 'react-native';
import { router } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Theme } from '../src/theme';

function FormField({ label, value, onChangeText, placeholder, trailingIcon, keyboardType }: {
  label: string; value: string; onChangeText: (t: string) => void;
  placeholder: string; trailingIcon?: keyof typeof Ionicons.glyphMap;
  keyboardType?: 'default' | 'email-address' | 'phone-pad';
}) {
  return (
    <View style={styles.fieldGroup}>
      <Text style={styles.fieldLabel}>{label}</Text>
      <View>
        <TextInput
          style={styles.input}
          placeholder={placeholder}
          value={value}
          onChangeText={onChangeText}
          keyboardType={keyboardType}
          placeholderTextColor={Theme.outline}
        />
        {trailingIcon && (
          <View style={styles.trailingIcon}>
            <Ionicons name={trailingIcon} size={13} color={Theme.outline} />
          </View>
        )}
      </View>
    </View>
  );
}

function FormSection({ icon, title, iconColor, children }: {
  icon: keyof typeof Ionicons.glyphMap; title: string;
  iconColor?: string; children: React.ReactNode;
}) {
  const color = iconColor || Theme.primary;
  return (
    <View style={styles.section}>
      <View style={styles.sectionHeader}>
        <Ionicons name={icon} size={14} color={color} />
        <Text style={[styles.sectionTitle, { color }]}>{title}</Text>
      </View>
      {children}
    </View>
  );
}

export default function PersonalInfoScreen() {
  const [name, setName] = useState('Alex Johnson');
  const [dob, setDob] = useState('May 14, 1988');
  const [email, setEmail] = useState('alex@safeflex.com');
  const [phone, setPhone] = useState('+1 (555) 123-4567');
  const [emergencyName, setEmergencyName] = useState('Sarah Johnson');
  const [emergencyPhone, setEmergencyPhone] = useState('+1 (555) 987-6543');
  const [saved, setSaved] = useState(false);

  const save = () => {
    setSaved(true);
    setTimeout(() => setSaved(false), 2500);
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()}>
          <Text style={styles.doneBtn}>Done</Text>
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Edit Personal Info</Text>
        <View style={{ width: 40 }} />
      </View>

      <ScrollView showsVerticalScrollIndicator={false}>
        {/* Avatar */}
        <View style={styles.avatarSection}>
          <View style={styles.avatarWrap}>
            <View style={styles.avatarCircle}>
              <Text style={styles.avatarText}>AJ</Text>
            </View>
            <View style={styles.editBadge}>
              <Ionicons name="pencil" size={11} color="#fff" />
            </View>
          </View>
          <Text style={styles.avatarName}>Alex Johnson</Text>
          <Text style={styles.avatarId}>Patient ID: SF-2934-PT</Text>
        </View>

        <FormSection icon="person" title="IDENTITY">
          <FormField label="Full Name" value={name} onChangeText={setName} placeholder="Alex Johnson" />
          <FormField label="Date of Birth" value={dob} onChangeText={setDob} placeholder="May 14, 1988" trailingIcon="calendar" />
        </FormSection>

        <FormSection icon="mail" title="CONTACT DETAILS">
          <FormField label="Email Address" value={email} onChangeText={setEmail} placeholder="alex@safeflex.com" keyboardType="email-address" />
          <FormField label="Phone Number" value={phone} onChangeText={setPhone} placeholder="+1 (555) 123-4567" keyboardType="phone-pad" />
        </FormSection>

        <FormSection icon="warning" title="EMERGENCY CONTACT" iconColor={Theme.error}>
          <FormField label="Contact Name" value={emergencyName} onChangeText={setEmergencyName} placeholder="Sarah Johnson" />
          <FormField label="Contact Phone" value={emergencyPhone} onChangeText={setEmergencyPhone} placeholder="+1 (555) 987-6543" keyboardType="phone-pad" />
        </FormSection>

        <TouchableOpacity
          style={[styles.saveBtn, saved && styles.saveBtnSaved]}
          onPress={save}
          activeOpacity={0.8}
        >
          <Ionicons name={saved ? 'checkmark' : 'download'} size={16} color="#fff" />
          <Text style={styles.saveBtnText}>{saved ? 'Saved!' : 'Save Changes'}</Text>
        </TouchableOpacity>

        <Text style={styles.footerText}>Your data is encrypted and stored securely.</Text>
        <View style={{ height: 32 }} />
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
  avatarSection: { alignItems: 'center', paddingVertical: 20 },
  avatarWrap: { position: 'relative' },
  avatarCircle: {
    width: 96, height: 96, borderRadius: 48,
    backgroundColor: '#DBEAFE', borderWidth: 3, borderColor: '#fff',
    alignItems: 'center', justifyContent: 'center',
    shadowColor: '#000', shadowOpacity: 0.1, shadowRadius: 8,
    shadowOffset: { width: 0, height: 4 },
  },
  avatarText: { fontSize: 34, fontWeight: '800', color: Theme.primary },
  editBadge: {
    position: 'absolute', right: -2, bottom: -2,
    width: 30, height: 30, borderRadius: 15,
    backgroundColor: Theme.primaryContainer, borderWidth: 2, borderColor: '#fff',
    alignItems: 'center', justifyContent: 'center',
    shadowColor: Theme.authAccent, shadowOpacity: 0.4, shadowRadius: 4,
    shadowOffset: { width: 0, height: 2 },
  },
  avatarName: { fontSize: 18, fontWeight: '700', color: Theme.onSurface, marginTop: 10 },
  avatarId: { fontSize: 11, color: Theme.secondary },
  section: {
    padding: 16, marginHorizontal: 20, marginBottom: 14,
    backgroundColor: 'rgba(255,255,255,0.72)', borderRadius: 14,
    borderWidth: 1, borderColor: 'rgba(255,255,255,0.45)',
    shadowColor: Theme.primary, shadowOpacity: 0.04, shadowRadius: 8,
    shadowOffset: { width: 0, height: 4 },
  },
  sectionHeader: {
    flexDirection: 'row', alignItems: 'center', gap: 8, marginBottom: 14,
  },
  sectionTitle: { fontSize: 11, fontWeight: '700', letterSpacing: 0.8 },
  fieldGroup: { marginBottom: 10 },
  fieldLabel: {
    fontSize: 11, fontWeight: '500', color: Theme.onSurfaceVariant,
    paddingLeft: 2, marginBottom: 5,
  },
  input: {
    height: 46, backgroundColor: 'rgba(255,255,255,0.65)',
    borderRadius: 9, borderWidth: 1, borderColor: Theme.outlineVariant,
    paddingHorizontal: 13, fontSize: 14, color: Theme.onSurface,
  },
  trailingIcon: {
    position: 'absolute', right: 12, top: 0, bottom: 0, justifyContent: 'center',
  },
  saveBtn: {
    flexDirection: 'row', gap: 8, marginHorizontal: 20,
    height: 52, borderRadius: 13, backgroundColor: Theme.primary,
    alignItems: 'center', justifyContent: 'center',
    shadowColor: Theme.primary, shadowOpacity: 0.4, shadowRadius: 8,
    shadowOffset: { width: 0, height: 4 }, marginTop: 4,
  },
  saveBtnSaved: { backgroundColor: '#15803D' },
  saveBtnText: { fontSize: 16, fontWeight: '700', color: '#fff' },
  footerText: {
    fontSize: 11, color: Theme.outline, textAlign: 'center',
    marginTop: 12,
  },
});
