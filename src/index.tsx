import {
  requireNativeComponent,
  UIManager,
  Platform,
  type ViewStyle,
} from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-svg-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

type SvgNativeProps = {
  uri: string;
  style: ViewStyle;
  defaultSize?: { width: number; height: number };
  cacheTime?: number;
};

const ComponentName = 'SvgNativeView';

export const SvgNativeView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<SvgNativeProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };
