import { useState } from 'react';
import {
  View, Text, TextInput, TouchableOpacity, ScrollView,
  StyleSheet, ActivityIndicator,
} from 'react-native';
import { router } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Theme } from '../../src/theme';
import { useAppState } from '../../src/store';

export default function SignInScreen() {
  const { setAuthenticated } = useAppState();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');

  const signIn = () => {
    if (!email || !password) {
      setErrorMessage('Please fill in all fields.');
      return;
    }
    setIsLoading(true);
    setErrorMessage('');
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

        {/* Back */}
        <TouchableOpacity style={styles.backBtn} onPress={() => router.back()}>
          <Ionicons name="chevron-back" size={12} color="rgba(255,255,255,0.55)" />
          <Text style={styles.backText}>Back</Text>
        </TouchableOpacity>

        <View style={{ height: 14 }} />

        {/* Header */}
        <View style={styles.header}>
          <View style={styles.shieldBox}>
            <Ionicons name="medkit" size={20} color="#fff" />
          </View>
          <Text style={styles.title}>Sign In</Text>
          <Text style={styles.subtitle}>Welcome back to your recovery journey.</Text>
        </View>

        <View style={{ height: 20 }} />

        {/* Form card */}
        <View style={styles.formCard}>
          {/* Email */}
          <View style={styles.fieldGroup}>
            <Text style={styles.fieldLabel}>EMAIL ADDRESS</Text>
            <TextInput
              style={styles.input}
              placeholder="name@example.com"
              placeholderTextColor="rgba(255,255,255,0.22)"
              value={email}
              onChangeText={setEmail}
              keyboardType="email-address"
              autoCapitalize="none"
              autoCorrect={false}
            />
          </View>

          {/* Password */}
          <View style={styles.fieldGroup}>
            <Text style={styles.fieldLabel}>PASSWORD</Text>
            <View>
              <TextInput
                style={styles.input}
                placeholder="••••••••"
                placeholderTextColor="rgba(255,255,255,0.22)"
                value={password}
                onChangeText={setPassword}
                secureTextEntry={!showPassword}
              />
              <TouchableOpacity
                style={styles.showBtn}
                onPress={() => setShowPassword(!showPassword)}
              >
                <Text style={styles.showBtnText}>
                  {showPassword ? 'HIDE' : 'SHOW'}
                </Text>
              </TouchableOpacity>
            </View>
            <TouchableOpacity style={styles.forgotRow}>
              <Text style={styles.forgotText}>Forgot password?</Text>
            </TouchableOpacity>
          </View>

          {errorMessage ? (
            <Text style={styles.error}>{errorMessage}</Text>
          ) : null}

          {/* Sign In button */}
          <TouchableOpacity
            style={[styles.primaryBtn, isLoading && styles.primaryBtnLoading]}
            onPress={signIn}
            disabled={isLoading}
            activeOpacity={0.8}
          >
            {isLoading ? (
              <ActivityIndicator color="#fff" />
            ) : (
              <Text style={styles.primaryBtnText}>Sign In →</Text>
            )}
          </TouchableOpacity>

          {/* Divider */}
          <View style={styles.divider}>
            <View style={styles.dividerLine} />
            <Text style={styles.dividerText}>or</Text>
            <View style={styles.dividerLine} />
          </View>

          {/* Apple Sign In */}
          <TouchableOpacity style={styles.appleBtn} onPress={signIn} activeOpacity={0.8}>
            <Ionicons name="logo-apple" size={16} color="#1A1A1A" />
            <Text style={styles.appleBtnText}>Sign in with Apple</Text>
          </TouchableOpacity>
        </View>

        {/* Sign up link */}
        <View style={styles.linkRow}>
          <Text style={styles.linkLabel}>Don't have an account?</Text>
          <TouchableOpacity onPress={() => router.push('/(auth)/signup')}>
            <Text style={styles.linkAction}>Sign up</Text>
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
    backgroundColor: 'rgba(37,99,235,0.12)',
    top: -80,
    right: -60,
  },
  glow2: {
    position: 'absolute',
    width: 250,
    height: 250,
    borderRadius: 125,
    backgroundColor: 'rgba(37,99,235,0.08)',
    bottom: 100,
    left: -80,
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
    width: 52,
    height: 52,
    borderRadius: 13,
    backgroundColor: Theme.authAccent,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: Theme.authAccent,
    shadowOpacity: 0.5,
    shadowRadius: 12,
    shadowOffset: { width: 0, height: 0 },
  },
  title: {
    fontSize: 26,
    fontWeight: '800',
    color: '#fff',
    letterSpacing: -0.5,
  },
  subtitle: {
    fontSize: 13,
    color: 'rgba(255,255,255,0.45)',
  },
  formCard: {
    marginHorizontal: 20,
    padding: 22,
    backgroundColor: Theme.authCard,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: Theme.authBorder,
    gap: 14,
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
  showBtn: {
    position: 'absolute',
    right: 14,
    top: 0,
    bottom: 0,
    justifyContent: 'center',
  },
  showBtnText: {
    fontSize: 10,
    fontWeight: '700',
    color: 'rgba(255,255,255,0.35)',
    letterSpacing: 0.5,
  },
  forgotRow: {
    alignSelf: 'flex-end',
  },
  forgotText: {
    fontSize: 12,
    fontWeight: '500',
    color: '#B4C5FF',
  },
  error: {
    fontSize: 12,
    color: '#FCA5A5',
  },
  primaryBtn: {
    height: 50,
    backgroundColor: Theme.authAccent,
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
  },
  primaryBtnLoading: {
    opacity: 0.6,
  },
  primaryBtnText: {
    fontSize: 16,
    fontWeight: '700',
    color: '#fff',
  },
  divider: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  dividerLine: {
    flex: 1,
    height: 1,
    backgroundColor: 'rgba(255,255,255,0.09)',
  },
  dividerText: {
    fontSize: 11,
    fontWeight: '500',
    color: 'rgba(255,255,255,0.28)',
  },
  appleBtn: {
    height: 48,
    backgroundColor: '#fff',
    borderRadius: 10,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
  },
  appleBtnText: {
    fontSize: 15,
    fontWeight: '700',
    color: '#1A1A1A',
  },
  linkRow: {
    flexDirection: 'row',
    justifyContent: 'center',
    gap: 4,
    paddingTop: 16,
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
