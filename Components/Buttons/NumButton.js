import {
	StyleSheet,
	Text,
	View,
	Pressable
} from "react-native";

import { setKeyPair, setDefault, selectID } from "../../Redux/Features/dataSlice.js";
import { useDispatch, useSelector } from "react-redux";
import { useTheme } from "@react-navigation/native";

export default function NumButton(props) {
	const dispatch = useDispatch();
	const { colors } = useTheme();

	// set default value
	dispatch(setDefault([props.id, props.default || 0]));
	// get value from store
	const value = useSelector(selectID(props.id));

	return (
		<Pressable
			onPress={() => {dispatch(setKeyPair([props.id, value + 1]));}}
			onLongPress={() => {dispatch(setKeyPair([props.id, Math.max((value - 1), 0)]));}}
		>
			<View style={{
				justifyContent: "center",
				borderRadius: 10,
				borderWidth: StyleSheet.hairlineWidth,
				borderColor: colors.border,
				backgroundColor: colors.background,
				width: (props.width ? props.width : 100),
				height: (props.height ? props.height : 40),
				margin: props.margin ?? 10,
				backgroundColor: colors.background,
				justifyContent: "center",
			}}>
				<Text style={{ textAlign: "center", color: colors.text, }}>{props.children} {`(${value})`}</Text>
			</View>
		</Pressable>
	);
}