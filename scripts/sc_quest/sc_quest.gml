// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum quest {
	placeholder,
	dread_pit,
	bounty_spider,
	money,
}

function init_quests() {
	global.quest_table = [
		newQuest(),
		newQuest(
			"Quest: Escape the Dread Pit",
			"I fell into this wicked pit. O accursed pit. I will get out.",
			quest.dread_pit,
			[	newQuestStep("Question the Pit Denizen","I fell into this wicked, dreadful pit but I am not alone. The nearby denizen of the dark may offer guidance."),
				newQuestStep("Move Forward","The pit denizen has been consulted, more or less. I should find my way forward."),
			],
			item_rarity.uncommon
			
		),
		newQuest(
			"Bounty: The Dread Pit of Avarus",
			"There are legends of a sublime creature lurking in the dark; I will stay sharp.",
			quest.bounty_spider,
			[
				newQuestStep("Hunt for the Sublime Creature","Now where could it be..."),
				newQuestStep("Hunt the Golden Spider","Such brilliance! Surely worth a fortune if I slay it!")
			],
			item_rarity.legendary
			
			
		),
		newQuest(
			"Goal: Accumulate Wealth",
			"I will become the richest of them all!",
			quest.money,
			[
				newQuestStep("Locate the Nearest Bank","If I find a bank, I could work for them, or rob it!")
			],
			item_rarity.very_rare
			
		)
	]
}

function newQuest(quest_name = "Placeholder Quest", quest_desc = "" , quest_id = quest.placeholder, quest_steps = [], quest_rarity = 0)
{
	var _q = 
	{
		qId		: quest_id,
		stage	: 1,
		step	: quest_steps,
		name	: quest_name,
		desc	: quest_desc,
		rarity	: quest_rarity,
		stageAdvance : function() {
			if (stage < array_length(step)) {
				stage += 1;
			}
		},
		stageReverse : function() {
			if (stage > 0) {
				stage -= 1;	
			}
		}
	}
	return _q;
}


function newQuestStep(step_name = "Placeholder Step", step_desc = "Placeholder Step Description", step_count = 1)
{
	var _qs =
	{
		name		: step_name,
		desc		: step_desc,
		count		: 0,
		countMax	: step_count,
		
	}
	return _qs;
}
