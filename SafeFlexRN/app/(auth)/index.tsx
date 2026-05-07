import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { router } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { Theme } from '../../src/theme';

const BAR_HEIGHTS = [38, 52, 44, 78, 55, 88, 68, 92, 74, 82];

export default function WelcomeScreen() {
  return (
    <View style={styles.container}>
      {/* Ambient glows */}
      <View style={styles.glow1} />
      <View style={styles.glow2} />

      <View style={styles.content}>
        <View style={{ height: 80 }} />

        {/* Brand */}
        <View style={styles.brand}>
          <View style={styles.brandRow}>
            <View style={styles.logoBox}>
              <Ionicons name="medkit" size={20} color="#fff" />
            </View>
            <Text style={styles.logoText}>SafeFlex</Text>
          </View>
          <Text style={styles.tagline}>
            {'Physical therapy that knows\nwhen you\'re cheating.'}
          </Text>
        </View>

        <View style={{ height: 24 }} />

        {/* Feature card */}
        <View style={styles.featureCard}>
          <View style={styles.featureIcon}>
            <Ionicons name="trending-up" size={28} color="#DBE1FF" />
          </View>
          <Text style={styles.featureTitle}>Precision Recovery</Text>
          <Text style={styles.featureSub}>
            {'Clinical-grade motion analysis\nin the palm of your hand.'}
          </Text>
          <View style={styles.barChart}>
            {BAR_HEIGHTS.map((h, i) => (
              <View
                key={i}
                style={[
                  styles.bar,
                  {
                    height: h * 0.32,
                    backgroundColor: `rgba(37,99,235,${0.22 + i * 0.07})`,
                  },
                ]}
              />
            ))}
          </View>
        </View>

        <View style={{ flex: 1 }} />

        {/* CTAs */}
        <View style={styles.ctas}>
          <TouchableOpacity
            style={styles.getStartedBtn}
            onPress={() => router.push('/(auth)/signup')}
            activeOpacity={0.8}
          >
            <Text style={styles.getStartedText}>Get Started</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.signInBtn}
            onPress={() => router.push('/(auth)/signin')}
            activeOpacity={0.8}
          >
            <Text style={styles.signInText}>Sign In</Text>
          </TouchableOpacity>

          <Text style={styles.footer}>
            Trusted by 500+ physical therapy clinics nationwide.
          </Text>
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Theme.authDark,
  },
  glow1: {
    position: 'absolute',
    width: 280,
    height: 280,
    borderRadius: 140,
    backgroundColor: 'rgba(37,99,235,0.07)',
    top: -60,
    right: -40,
  },
  glow2: {
    position: 'absolute',
    width: 240,
    height: 240,
    borderRadius: 120,
    backgroundColor: 'rgba(30,58,138,0.16)',
    bottom: 200,
    left: -60,
  },
  content: {
    flex: 1,
  },
  brand: {
    alignItems: 'center',
    gap: 12,
  },
  brandRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 11,
  },
  logoBox: {
    width: 48,
    height: 48,
    borderRadius: 13,
    backgroundColor: Theme.authAccent,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: Theme.authAccent,
    shadowOpacity: 0.55,
    shadowRadius: 14,
    shadowOffset: { width: 0, height: 0 },
  },
  logoText: {
    fontSize: 30,
    fontWeight: '800',
    color: '#fff',
    letterSpacing: -0.9,
  },
  tagline: {
    fontSize: 16,
    fontWeight: '600',
    color: '#CBD5E1',
    textAlign: 'center',
    lineHeight: 22,
  },
  featureCard: {
    marginHorizontal: 20,
    padding: 22,
    backgroundColor: 'rgba(255,255,255,0.045)',
    borderRadius: 20,
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.1)',
    alignItems: 'center',
    gap: 4,
  },
  featureIcon: {
    width: 68,
    height: 68,
    borderRadius: 16,
    backgroundColor: 'rgba(37,99,235,0.18)',
    borderWidth: 1,
    borderColor: 'rgba(37,99,235,0.3)',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 8,
  },
  featureTitle: {
    fontSize: 18,
    fontWeight: '800',
    color: '#fff',
    letterSpacing: -0.3,
  },
  featureSub: {
    fontSize: 13,
    color: '#94A3B8',
    textAlign: 'center',
    lineHeight: 18,
  },
  barChart: {
    flexDirection: 'row',
    alignItems: 'flex-end',
    gap: 5,
    height: 32,
    marginTop: 8,
  },
  bar: {
    width: 7,
    borderRadius: 3,
  },
  ctas: {
    paddingHorizontal: 20,
    paddingBottom: 40,
    gap: 10,
  },
  getStartedBtn: {
    height: 54,
    backgroundColor: Theme.authAccent,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: Theme.authAccent,
    shadowOpacity: 0.42,
    shadowRadius: 10,
    shadowOffset: { width: 0, height: 4 },
  },
  getStartedText: {
    fontSize: 17,
    fontWeight: '800',
    color: '#fff',
    letterSpacing: -0.3,
  },
  signInBtn: {
    height: 54,
    backgroundColor: 'rgba(255,255,255,0.07)',
    borderRadius: 14,
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.18)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  signInText: {
    fontSize: 17,
    fontWeight: '800',
    color: '#fff',
  },
  footer: {
    fontSize: 11,
    fontWeight: '500',
    color: '#475569',
    textAlign: 'center',
  },
});
