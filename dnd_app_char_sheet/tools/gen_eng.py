import csv
import json

def csv_to_json(csv_file_path, json_file_path):
    spells = []

    with open(csv_file_path, mode='r', encoding='gbk') as csv_file:
        csv_reader = csv.DictReader(csv_file)
        for row in csv_reader:
            spell = {
                "name": row["Spell Name"],  # 法术名 -> Spell Name
                "level": row["Level"],  # 环阶 -> Level
                "school": row["School"],  # 学派 -> School
                "ritual": row["Ritual"] == "√",  # 仪式 -> Ritual
                "castingTime": row["Casting Time"],  # 施法时间 -> Casting Time
                "range": row["Range"],  # 施法距离 -> Range
                "verbal": row["V Verbal"] == "V",  # V 言语 -> V Verbal
                "somatic": row["S Somatic"] == "S",  # S 姿势 -> S Somatic
                "material": row["M Material"] == "M",  # M 材料 -> M Material
                "materialComponents": row["Material Components"],  # 材料内容 -> Material Components
                "duration": row["Duration"],  # 持续时间 -> Duration
                "description": row["Spell Description"],  # 法术详述 -> Spell Description
                "englishName": row["English Name"],  # 英文名 -> English Name
                "classes": [
                    "Bard" if row["Bard"] == "√" else None,  # 吟游诗人 -> Bard
                    "Cleric" if row["Cleric"] == "√" else None,  # 牧师 -> Cleric
                    "Druid" if row["Druid"] == "√" else None,  # 德鲁伊 -> Druid
                    "Paladin" if row["Paladin"] == "√" else None,  # 圣武士 -> Paladin
                    "Ranger" if row["Ranger"] == "√" else None,  # 游侠 -> Ranger
                    "Sorcerer" if row["Sorcerer"] == "√" else None,  # 术士 -> Sorcerer
                    "Warlock" if row["Warlock"] == "√" else None,  # 邪术师 -> Warlock
                    "Wizard" if row["Wizard"] == "√" else None,  # 法师 -> Wizard
                    "Artificer" if row["Artificer"] == "√" else None,  # 奇械师 -> Artificer
                    "Mage" if row["Mage"] == "√" else None,
                    "Time Wizard" if row["Time Wizard"] == "√" else None,  # 时间法师 -> Time Wizard (Este é um subtipo de Mago, pode precisar de ajuste dependendo do seu sistema)
                    "Gravity Wizard" if row["Gravity Wizard"] == "√" else None  # 重力法师 -> Gravity Wizard (Este é um subtipo de Mago, pode precisar de ajuste dependendo do seu sistema)
                ],
                "source": row["Source"]  # 出处 -> Source
            }
            # Remove None values from classes
            spell["classes"] = [cls for cls in spell["classes"] if cls is not None]
            spells.append(spell)

    with open(json_file_path, mode='w', encoding='utf-8') as json_file:
        json.dump(spells, json_file, ensure_ascii=False, indent=4)

# Example usage
csv_to_json('tools/data_eng.csv', 'assets/spells_eng.json')