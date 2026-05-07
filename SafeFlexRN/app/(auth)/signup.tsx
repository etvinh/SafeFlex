import { useState } from 'react';
import {
  View, Text, TextInput, TouchableOpacity, ScrollView,
  StyleSheet, ActivityIndicator,
} from 'react-native';
import { router } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Theme } from '../../src/theme';
import { useAppState } from '../../src/store';

function AuthField({
  label, value, onChangeText, placeholder, secureTextEntry, keyboardType,
}: {
  label: string;
  value: string;
  onChangeText: (t: string) => void;
  placeholder: string;
  secureTextEntry?: boolean;
  keyboardType?: 'default' | 'email-address';
}) {
  return (
    <View style={styles.fieldGroup}>
      <Text style={styles.fieldLabel}>{label}</Text>
      <TextInput
        style={styles.input}
        placeholder={placeholder}
        placeholderTextColor="rgba(255,255,255,0.22)"
        value={value}
        onChangeText={onChangeText}
        secureTextEntry={secureTextEntry}
        keyboardType={keyboardType}
        autoCapitalize={keyboardType === 'email-address' ? 'none' : 'words'}
        autoCorrect={false}
      />
    </View>
  );
}

export default function SignUpScreen() {
  const { setAuthenticated } = useAppState();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const createAccount = () => {
    if (!name || !email || !password) return;
    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
      setAuthenticated(true);
      router.replace('/(tabs)');
    }, 1100);
  };

  return (
    <View style={styles.container}>
      <View style={styles.glow1} />
      <View style={styles.glow2} />
      <ScrollView showsVerticalScrollIndicator={false}>
        <View style={{ height: 16 }} />

        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Ionicons name="chevron-back" size={12} color="rgba(255,255,255,0.55)" />
          <Text style={styles.backText}>Back</Text>
        </TouchableOpacity>

        <View style={{ height: 12 }} />

        {/* Header */}
        <View style={styles.header}>
          <View style={styles.shieldBox}>
            <Ionicons name="medkit" size={19} color="#fff" />
          </View>
          <Text style={styles.title}>Create Account</Text>
          <Text style={styles.subtitle}>Start your recovery journey today.</Text>
        </View>

        <View style={{ height: 18 }} />

        {/* Form card */}
        <View style={styles.formCard}>
          <AuthField label="FULL NAME" value={name} onChangeText={setName} placeholder="Alex Johnson" />
          <AuthField label="EMAIL ADDRESS" value={email} onChangeText={setEmail} placeholder="name@example.com" keyboardType="email-address" />
          <AuthField label="PASSWORD" value={password} onChangeText={setPassword} placeholder="8+ characters" secureTextEntry />

          <TouchableOpacity
            style={[styles.primaryBtn, isLoading && styles.primaryBtnLoading]}
            onPress={createAccount}
            disabled={isLoading}
            activeOpacity={0.8}
          >
            {isLoading ? (
              <ActivityIndicator color="#fff" />
            ) : (
              <Text style={styles.primaryBtnText}>Create Account →</Text>
            )}
          </TouchableOpacity>

          <Text style={styles.terms}>
            By creating an account you agree to our Terms of Service and Privacy Policy.
          </Text>
        </View>

        {/* Sign in link */}
        <View style={styles.linkRow}>
          <Text style={styles.linkLabel}>Already have an account?</Text>
          <TouchableOpacity onPress={() => router.push('/(auth)/signin')}>
            <Text style={styles.linkAction}>Sign in</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0C1222',
  },
  glow1: {
    position: 'absolute',
    width: 300,
    height: 300,
    borderRadius: 150,
    backgroundColor: 'rgba(37,99,235,0.14)',
    top: -100,
    left: -60,
  },
  glow2: {
    position: 'absolute',
    width: 250,
    height: 250,
    borderRadius: 125,
    backgroundColor: 'rgba(30,58,138,0.18)',
    bottom: 80,
    right: -60,
  },
  backBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 5,
    paddingHorizontal: 20,
  },
  backText: {
    fontSize: 15,
    fontWeight: '500',
    color: 'rgba(255,255,255,0.55)',
  },
  header: {
    alignItems: 'center',
    gap: 6,
  },
  shieldBox: {
    width: 48,
    height: 48,
    borderRadius: 13,
    backgroundColor: Theme.authAccent,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: Theme.authAccent,
    shadowOpacity: 0.5,
    shadowRadius: 11,
    shadowOffset: { width: 0, height: 0 },
  },
  title: {
    fontSize: 24,
    fontWeight: '800',
    color: '#fff',
    letterSpacing: -0.5,
  },
  subtitle: {
    fontSize: 13,
    color: 'rgba(255,255,255,0.4)',
  },
  formCard: {
    marginHorizontal: 20,
    padding: 22,
    backgroundColor: Theme.authCard,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: Theme.authBorder,
    gap: 13,
  },
  fieldGroup: {
    gap: 5,
  },
  fieldLabel: {
    fontSize: 11,
    fontWeight: '600',
    color: Theme.authLabel,
    letterSpacing: 0.7,
  },
  input: {
    height: 48,
    backgroundColor: Theme.authInputBg,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: Theme.authInputBorder,
    paddingHorizontal: 14,
    fontSize: 15,
    color: '#fff',
  },
  primaryBtn: {
    height: 50,
    backgroundColor: Theme.authAccent,
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 4,
  },
  primaryBtnLoading: {
    opacity: 0.6,
  },
  primaryBtnText: {
    fontSize: 16,
    fontWeight: '700',
    color: '#fff',
  },
  terms: {
    fontSize: 10,
    color: 'rgba(255,255,255,0.22)',
    textAlign: 'center',
    lineHeight: 15,
  },
  linkRow: {
    flexDirection: 'row',
    justifyContent: 'center',
    gap: 4,
    paddingTop: 14,
    paddingBottom: 28,
  },
  linkLabel: {
    fontSize: 13,
    color: 'rgba(255,255,255,0.38)',
  },
  linkAction: {
    fontSize: 13,
    fontWeight: '700',
    color: '#B4C5FF',
  },
});
