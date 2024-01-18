import {
	StyleSheet,
	View,
	Text,
	Image,
	Pressable,
	ImageBackground
} from "react-native";
//import { Text } from "../../Components/Themed/Text";

import { setKeyPair, setDefault, selectID } from "../../Redux/Features/dataSlice.js";
import { useDispatch, useSelector } from "react-redux";
import { useTheme } from "@react-navigation/native";

const coneImage = () => <Image style={{flex: 1, width: 50, height: 50}} source={require("../../Assets/2023/2023Cone.png")} />;
const cubeImage = () => <Image style={{flex: 1, width: 50, height: 50}} source={require("../../Assets/2023/2023Cube.png")} />;
const redGrid = require("../../Assets/2023/RedGrid.png");
const blueGrid = require("../../Assets/2023/BlueGrid.png");

function ConeButton(props) {
	const dispatch = useDispatch();
	const { colors } = useTheme();

	// set default value
	dispatch(setDefault([props.id, props.default || 0]));
	// get value from store
	const value = useSelector(selectID(props.id));

	return (
		<Pressable
			style={[styles.button, { borderColor: colors.border }]}
			onPress={() => { dispatch(setKeyPair([props.id, (value+1)%2])); }}
		>
			{
				value===0? (<Text style={{textAlign: "center"}}>Empty</Text>) :
				(coneImage)
			}
		</Pressable>
	);
}

function BoxButton(props) {
	const dispatch = useDispatch();
	const { colors } = useTheme();

	// set default value
	dispatch(setDefault([props.id, props.default || 0]));
	// get value from store
	const value = useSelector(selectID(props.id));

	return (
		<Pressable
			style={[styles.button, { borderColor: colors.border }]}
			onPress={() => { dispatch(setKeyPair([props.id, (value+1)%2])); }}
		>
			{
				value===0? (<Text style={{textAlign: "center"}}>Empty</Text>) :
				(cubeImage)
			}
		</Pressable>
	);
}

function ConeBoxButton(props) {
	const dispatch = useDispatch();
	const { colors } = useTheme();

	// set default value
	dispatch(setDefault([props.id, props.default || 0]));
	// get value from store
	const value = useSelector(selectID(props.id));

	return (
		<Pressable
			style={[styles.button, { borderColor: colors.border }]}
			onPress={() => { dispatch(setKeyPair([props.id, (value+1)%3])); }}
		>
			{
				value===0? (<Text style={{textAlign: "center"}}>Empty</Text>) :
				value===1? (coneImage) :
				(cubeImage)
			}
		</Pressable>
	);
}


export default function Grid(props) {
	const dispatch = useDispatch();
	const { colors } = useTheme();
	const arenaID = "Team";

	// set default value
	dispatch(setDefault([arenaID, 0]));
	const selectedTeam = useSelector(selectID(arenaID));
	// grid ID
	const gridID = props.id;

	const width = 1415/1.5,
		  height = 324/1.5;

	// 0 is Cone, 1 is Box, 2 is ConeBox
	// i am so sorry for this code
	const boxes = [[0, 1, 0,    0, 1, 0,    0, 1, 0],
				   [0, 1, 0,    0, 1, 0,    0, 1, 0],
				   [2, 2, 2,    2, 2, 2,    2, 2, 2]];
	
	return (
		<View>
			<ImageBackground
				source={selectedTeam? redGrid : blueGrid}
				style={{ width: width, height: height, marginTop: 20 }}
				imageStyle={{ borderRadius: 10, borderColor: colors.border }}
			>
				{boxes.map((row, i) => 
					row.map((c, o) => {
						const positionStyle = {
							position: "absolute",
							left: (width/9)*o + (50/2),
							top: (height/3)*i,
							backgroundColor: "#DDDDDD88"
						}
					
						// 0 is Cone, 1 is Box, 2 is ConeBox
						return (
							<View style={positionStyle} key={`${gridID}-${i}-${o}`}>
								{(c===0)? <ConeButton  id={`${gridID}-${i}-${o}`} /> :
								 (c===1)? <BoxButton   id={`${gridID}-${i}-${o}`} /> :
										<ConeBoxButton id={`${gridID}-${i}-${o}`} />}
							</View>
						);
					})
				)}
			</ImageBackground>
		</View>
	);
}


const styles = StyleSheet.create({
	button: {
		justifyContent: "center",
		borderRadius: 10,
		borderWidth: StyleSheet.hairlineWidth,
		margin: 10,
		height: 50,
		width: 50
	}
})