import { StyleSheet, View } from 'react-native';
import { SvgNativeView } from 'react-native-svg-native';

export default function App() {
  return (
    <View style={styles.container}>
      <SvgNativeView
        uri="https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/tiger.svg"
        style={styles.svg}
        cacheTime={86400000} // Cache time in milliseconds (e.g., 1 day)
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  svg: {
    width: 200,
    height: 200,
  },
});
