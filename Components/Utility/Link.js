import {
	StyleSheet,
	Text,
	View
} from "react-native";

export default function Link(props) {
	return (
		<View style={styles.container}>
			<Text
				style={{ color: props.color, fontSize: 17 }}
				onPress={props.onPress}
			>
				{props.children}
			</Text>
		</View>
	);
}

const styles = StyleSheet.create({
	container: {
		alignItems: "center",
		flex: 1
	}
});
