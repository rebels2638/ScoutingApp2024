import {
	View,
	ScrollView,
	StyleSheet,
	Image,
	Linking,
	Dimensions
} from "react-native";
import { Text } from "../Components/Themed/Text";
import RadioButton from "../Components/Buttons/RadioButton";
import Link from "../Components/Utility/Link";
import Header from "./AboutComponents/Header";

import themes from "../Config/Themes";
import AsyncStorage from "@react-native-async-storage/async-storage";

export default function About() {
	const title = input => <Text style={styles.title}>{input}</Text>;
	const text = input => <Text style={styles.text}>{input}</Text>;
	const person = (title, name) => <Text style={styles.text}><Text style={styles.underline}>{title}</Text> {name}</Text>;
	const spacer = <Text>{"\n\n"}</Text>;

	return (
		<View style={{ flex: 1 }}>
			<View style={{ height: Dimensions.get('window').height*0.123 }}>
				<Header />
			</View>

			<View style={{ flex: 1 }}>
				<ScrollView>
					<View style={styles.credits}>
						<Image
							source={require("../Assets/appicon.png")}
							style={styles.image}
						/>

						{title("2638 Scout")}
						{text("Version 5.0.0 3/20/2023")}

						{spacer}
						{text("Custom Theme")}
						<RadioButton 
							id="ThemeSelector"
							data={["auto", ...Object.keys(themes)]}
							default="auto"
							onPress={(i) => AsyncStorage.setItem("theme", i+"")}
							bgc="orange"
							segmentedButton
						/>

						{spacer}

						{title("UI Design and Concept by")}
						{person("App Designer", "Reid Fleishman")}

						{spacer}

						{title("App Development Team (React Native)")}
						{person("Developer", "Kevin Wang")}
						{person("Developer", "Aiden Pan")}
						{person("Developer", "Eric Yachabes")}
						{person("Developer", "Aidan Din")}

						{spacer}

						{title("Tools Used")}
						{text("React Native")}
						{text("Expo")}
						{text("VSCode")}
						{text("Github Codespaces")}
						<Link onPress={() => Linking.openURL("https://github.com/rebels2638/ScoutingApp2023")}>{title("Check out our code on Github")}</Link>

						{spacer}

						{title("Special Thanks To")}
						{text("John Motchkavitz")}
						{text("Matthew Corrigan")}
						{text("Andrea Zinn")}
						{text("George Motchkavitz")}
						{text(<Text style={styles.italic}>And all of our amazing mentors!</Text>)}

						{spacer}

						{text("Questions or Comments? Please email reidfleishman5@gmail.com")}

						{title("© 2023 Rebel Robotics")}
						<Link onPress={() => Linking.openURL('https://gnsrobotics.com')}>{title("gnsrobotics.com")}</Link>
					</View>
				</ScrollView>
			</View>
		</View>
	);
}

const styles = StyleSheet.create({
	credits: {
		alignItems: "center",
		justifyContent: "center",
		paddingBottom: 50
	},
	flex: { flex: 1 },
	image: {
		borderRadius: 10,
		height: 350,
		margin: 10,
		width: 350
	},
	italic: { fontStyle: "italic" },
	text: { fontSize: 16 },
	title: {
		fontSize: 16,
		fontWeight: "bold",
		textDecorationLine: "underline"
	},
	underline: {
		fontSize: 16,
		textDecorationLine: "underline"
	}
});
