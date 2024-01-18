import { Text as RNText } from "react-native";
import { useTheme } from '@react-navigation/native';

export function Text(props) {
	const { colors } = useTheme();
	const { children, ...p } = props;
	p.style = ({...p.style, ...{color: colors.text}});

	return (
		<RNText {...p}>{children}</RNText>
	);
}

export default { Text }