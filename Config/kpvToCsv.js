function TakeTheSoulFromGrids(kpv, gridID) {
	// empty grid with 3 rows, 9 columns
	let grid = new Array(3).fill(new Array(9).fill(0));

	// 0 is Cone, 1 is Box, 2 is ConeBox
	const boxes = [[0, 1, 0,    0, 1, 0,    0, 1, 0],
				[0, 1, 0,    0, 1, 0,    0, 1, 0],
				[2, 2, 2,    2, 2, 2,    2, 2, 2]];
				
	// 0 is None, 1 is Cone, 2 is Cube
	// map answer based on whether it's a cube/cone/cubecone
	grid = boxes.map((row, i) => row.map((v, o) => {
		// ConeButton and ConeBoxButton both return their normal values,
		// but for CubeButton, it needs to manually be mapped to the correct values
		// check if it's a CubeButton with (v===1) and add the correct multiplier
		return kpv[`${gridID}-${i}-${o}`] * ((v === 1)? 2 : 1);
	}));

	// get it into the format Vincent wants it in
	grid = grid.map(row => row.map(v => ["na", "cn", "cb"][v]));

	return grid.map(row => row.join(",")).join("|");
}

// the holy grail contains all the data for converting the kpv's to one giant csv file
const theHolyGrail = [
	{ // match info
		name: "Match Type",
		vf: kpv => ["Practice", "Qual", "Playoff"][kpv["MatchType"]]
	}, {
		name: "Match Number",
		vf: kpv => kpv["MatchNumber"]
	}, {
		name: "Alliance",
		vf: kpv => ["Blue", "Red"][kpv["Team"]]
	}, {
		name: "Team Number",
		vf: kpv => kpv["TeamNumber"]
	},  {
		name: "Starting Position",
		vf: kpv => ["Left", "Mid", "Right"][kpv["StartingPosition"]]
	},

	// auto
	{
		name: "Taxi",
		vf: kpv => +kpv["Taxi"]
	}, {
		name: "Auto Position Scored",
		vf: kpv => TakeTheSoulFromGrids(kpv, "AutoGrid")
	}, {
		name: "Auto Missed",
		vf: kpv => +kpv["AutoMissed"]
	}, {
		name: "Auto Climb",
		vf: kpv => ["None", "Docked", "Engaged", "Failed"][kpv["AutoClimb"]]
	}, {
		name: "Auto Time to Engaged",
		vf: kpv => +kpv["AutoTimeToEngaged"]
	}, {
		name: "Auto Comment",
		vf: kpv => kpv["AutonomousComments"]
	}, 
	
	// tele-op
	{
		name: "Tele-Op Position Scored",
		vf: kpv => TakeTheSoulFromGrids(kpv, "TeleopGrid")
	}, {
		name: "Tele-Op Missed",
		vf: kpv => +kpv["TeleOpMissed"]
	}, {
		name: "Play Defense?",
		vf: kpv => +kpv["PlaysDefense"]
	}, {
		name: "Was Defended?",
		vf: kpv => +kpv["WasDefended"]
	}, {
		name: "Tele-Op Comment",
		vf: kpv => kpv["TeleopComments"]
	}, 

	// endgame
	{
		name: "Endgame Climb",
		vf: kpv => ["None", "Parked", "Docked", "Engaged", "Failed"][kpv["EndgameClimb"]]
	}, {
		name: "Endgame Time to Engaged",
		vf: kpv => +kpv["EndgameTimeToEngaged"]
	}, {
		name: "Number of Robot Climbed",
		vf: kpv => +kpv["NumRoboClimbed"]
	}, {
		name: "Endgame Comment",
		vf: kpv => kpv["EndgameComments"]
	}, 

	// other
	{
		name: "Breakdown?",
		vf: kpv => +kpv["Breakdown"]
	}, {
		name: "Ground Pickup?",
		vf: kpv => +kpv["GroundPickup"]
	}, {
		name: "Chute Pickup",
		vf: kpv => +kpv["ChutePickup"]
	}, {
		name: "Platform Pickup",
		vf: kpv => +kpv["PlatformPickup"]
	}, {
		name: "Game Piece Pickup",
		vf: kpv => ["Cone", "Cube", "Both"][kpv["GamePiecePickup"]]
	}, {
		name: "Alliance Position Scored",
		vf: kpv => TakeTheSoulFromGrids(kpv, "AllianceScoredPosition")
	}
];



// as the name suggests, kpvToCsv takes the important parts of the kpv, and converts it into a neat csv.
// matches: KPV[]
export default function kpvToCsv(matches) {
	let csv = "";

	// make header
	const header = [];
	theHolyGrail.forEach(col => {
		// escape quotes
		const filteredCell = col.name.replaceAll("\"", "\"\"");
		// https://stackoverflow.com/a/566059/12894940
		// the quotes around the cell ensure the newlines and commas are encoded properly.
		header.push(`"${filteredCell}"`);
	});

	csv += header.join(",") + "\r\n";

	// now we make the body
	// loop through each match
	matches.forEach(match => {
		const kpv = match[1];
		const row = [];
		// loop through each column, and calculate the row's values.
		theHolyGrail.forEach(col => {
			const filteredCell =
				// the result needs to be a string so we can use .replaceAll
				("" + col.vf(kpv))
					// fix 2020#11
					.replaceAll("\"", "\"\"");

			row.push(`"${filteredCell}"`);
		});

		csv += row.join(",") + "\r\n";
	});
	return csv;
}

// this is specifically for the QR code generation
export function kpvToString(match) {
	let result = "";

	const kpv = match[1];
	const row = [];
	// loop through each column, and calculate the row's values.
	theHolyGrail.forEach(col => {
		const filteredCell =
			// the result needs to be a string so we can use .replaceAll
			("" + col.vf(kpv))
				// fix 2020#11
				.replaceAll("\"", "\"\"");
		row.push(`${filteredCell}`);
	});
	result += row.join(";") + "\r\n";

	return result;
}