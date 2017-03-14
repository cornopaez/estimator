$(document).ready(function(){

	/*Governs the behavior of the Glyphicon-Remove*/
	$(".empty-procedure").click(function(){
		$(".procedure").val("");
		$(".zip").val("");
		this.style.visibility = "hidden";
	});

	/*Initialize the Autocomplete for the first time*/
	$(".procedure").autocomplete({
		source: [],
		minLength: 0
	});

	/*Timer offset for the input. This allows the user to complete input
	before calling the data from the dataset
	-----------------------------------------------------------------------*/
	var typingTimer;
	var doneTypingInterval = 700;

	$(".procedure").on("input", function(){
	    clearTimeout(typingTimer);
	    if ($(".procedure").val()) {
	        typingTimer = setTimeout(autoCompleteData, doneTypingInterval);
	    }
	});

	/*Procedure for Autocomplete*/
	var autoCompleteData = function(){

		/*Display SVG for feedback*/
		document.querySelector(".loading").style.visibility = "visible";

		var wordsInString = $(".procedure").val().split(" ");
		var url = "https://data.cms.gov/resource/cng4-92f3.json?$select=hcpcs_description,count(hcpcs_description)&$group=hcpcs_description&$limit=10&$order=count(hcpcs_description)%20DESC&$where=";
		var callParams = "";
		var app_token = "0JuHmJcY5dUjf7LSWPljvfmvp";
		var autoCompleteDataArray = []; //This is the array for the autocomplete function 

		// console.log("Built variables");

		/*Build parameter string*/
		for (var i = 0; i < wordsInString.length; i++) {

			//Create a new string to cover for capitalizations in dataset
			var tempWord = "_" + wordsInString[i].substring(1, wordsInString[i].length);

			if (i !== 0) {
				callParams += "%20AND%20";
			}
			callParams += "hcpcs_description%20like%20%27%25" + encodeURIComponent(tempWord) + "%25%27";
		};

		// console.log("Built parameters for query");

		$.ajax({
			url: url + callParams,
			type: "GET",
			data: {
				"$$app_token" : app_token,
			},
			cache: false
		}).done(function(data){

			// console.log("Got some data");

			//Populate the array
			for(var i = 0; i < data.length; i++){
				autoCompleteDataArray.push(data[i].hcpcs_description);
			};

			/*Change the source*/
			$(".procedure").autocomplete("option", "source", autoCompleteDataArray);

			/*Make menu visible*/
			$(".procedure").autocomplete("search", "");

			/*Hide SVG for feedback*/
			document.querySelector(".loading").style.visibility = "hidden";

			/*Show the Glyphicon-Remove*/
			document.querySelector(".empty-procedure").style.visibility = "visible";
		});
	};
});