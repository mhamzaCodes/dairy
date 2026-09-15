import 'package:flutter/material.dart';

/// Data Model representing a Cattle Breed in the Educational Encyclopedia.
class BreedModel {
  final String id;
  final String name;
  final String species; // 'Cow' or 'Buffalo'
  final String origin;
  final String yieldPerLactation;
  final double fatPercentage;
  final String description;
  final String imagePath;

  const BreedModel({
    required this.id,
    required this.name,
    required this.species,
    required this.origin,
    required this.yieldPerLactation,
    required this.fatPercentage,
    required this.description,
    required this.imagePath,
  });

  bool get isCow => species.toLowerCase() == 'cow';
  bool get isBuffalo => species.toLowerCase() == 'buffalo';

  IconData get iconData => isCow ? Icons.pets : Icons.water_drop;

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      origin: json['origin'] as String,
      yieldPerLactation: json['avg_yield_per_lactation_liters'] as String,
      fatPercentage: (json['avg_fat_percentage'] as num).toDouble(),
      description: json['description'] as String,
      imagePath: json['image_path'] as String,
    );
  }

  static final List<BreedModel> defaultBreeds = _rawBreeds.map((e) => BreedModel.fromJson(e)).toList();

  static const List<Map<String, dynamic>> _rawBreeds = [
  {
    "id": "breed_001",
    "name": "Holstein Friesian",
    "species": "Cow",
    "origin": "Netherlands",
    "avg_yield_per_lactation_liters": "8000-12000",
    "avg_fat_percentage": 3.7,
    "description": "A large black-and-white dairy breed recognized for exceptional milk production. It performs best in temperate climates but can adapt to warmer regions with shade, cooling, and proper nutrition.",
    "image_path": "assets/images/breeds/holstein_friesian.png"
  },
  {
    "id": "breed_002",
    "name": "Jersey",
    "species": "Cow",
    "origin": "Jersey, Channel Islands",
    "avg_yield_per_lactation_liters": "4500-7000",
    "avg_fat_percentage": 5.2,
    "description": "A small to medium-sized breed with a fawn-colored coat, refined head, and dark eyes. Jersey cows tolerate warm conditions relatively well and produce milk rich in butterfat and protein.",
    "image_path": "assets/images/breeds/jersey.png"
  },
  {
    "id": "breed_003",
    "name": "Brown Swiss",
    "species": "Cow",
    "origin": "Switzerland",
    "avg_yield_per_lactation_liters": "6500-9000",
    "avg_fat_percentage": 4.0,
    "description": "A large, sturdy breed with a brown-to-gray coat, strong legs, and a calm temperament. It adapts well to mountainous and varied climates and is valued for persistent lactation and good milk protein content.",
    "image_path": "assets/images/breeds/brown_swiss.png"
  },
  {
    "id": "breed_004",
    "name": "Ayrshire",
    "species": "Cow",
    "origin": "Scotland",
    "avg_yield_per_lactation_liters": "5500-7500",
    "avg_fat_percentage": 4.0,
    "description": "A medium-sized breed with distinctive red-and-white markings and a strong, angular body. Ayrshires are hardy grazers that perform well in cool and temperate climates and produce milk with useful solids content.",
    "image_path": "assets/images/breeds/ayrshire.png"
  },
  {
    "id": "breed_005",
    "name": "Guernsey",
    "species": "Cow",
    "origin": "Guernsey, Channel Islands",
    "avg_yield_per_lactation_liters": "5000-7000",
    "avg_fat_percentage": 4.5,
    "description": "A medium-sized breed with a golden-red or fawn coat, often featuring white markings. It is suited to temperate grazing systems and produces milk with relatively high butterfat and a naturally golden hue.",
    "image_path": "assets/images/breeds/guernsey.png"
  },
  {
    "id": "breed_006",
    "name": "Milking Shorthorn",
    "species": "Cow",
    "origin": "England",
    "avg_yield_per_lactation_liters": "5000-7000",
    "avg_fat_percentage": 3.8,
    "description": "A versatile breed with red, white, or roan coloring and a strong medium-to-large frame. It adapts to various management systems and offers dependable milk production, fertility, and hardiness.",
    "image_path": "assets/images/breeds/milking_shorthorn.png"
  },
  {
    "id": "breed_007",
    "name": "Sahiwal",
    "species": "Cow",
    "origin": "Punjab, Pakistan and India",
    "avg_yield_per_lactation_liters": "1800-3000",
    "avg_fat_percentage": 4.5,
    "description": "A reddish-brown zebu breed with loose skin, a prominent dewlap, and strong heat tolerance. Sahiwal cows are well adapted to hot South Asian climates and are among the highest-yielding indigenous dairy breeds.",
    "image_path": "assets/images/breeds/sahiwal.png"
  },
  {
    "id": "breed_008",
    "name": "Cholistani",
    "species": "Cow",
    "origin": "Cholistan Desert, Punjab, Pakistan",
    "avg_yield_per_lactation_liters": "1200-1800",
    "avg_fat_percentage": 4.5,
    "description": "A hardy indigenous breed commonly displaying white or light coloring with brown or black patches. It is adapted to the hot, dry conditions of the Cholistan region and provides useful milk production under low-input farming conditions.",
    "image_path": "assets/images/breeds/cholistani.png"
  },
  {
    "id": "breed_009",
    "name": "Red Sindhi",
    "species": "Cow",
    "origin": "Sindh, Pakistan",
    "avg_yield_per_lactation_liters": "1500-2500",
    "avg_fat_percentage": 4.5,
    "description": "A compact-to-medium-sized breed with a characteristic deep red coat and well-developed hump. Red Sindhi cattle are highly tolerant of heat and humidity and maintain useful milk production in tropical conditions.",
    "image_path": "assets/images/breeds/red_sindhi.png"
  },
  {
    "id": "breed_010",
    "name": "Gir",
    "species": "Cow",
    "origin": "Gujarat, India",
    "avg_yield_per_lactation_liters": "1800-3000",
    "avg_fat_percentage": 4.5,
    "description": "A distinctive zebu breed with a rounded forehead, long pendulous ears, and a red-and-white or speckled coat. Gir cattle are well suited to hot climates and are valued for heat tolerance, disease resistance, and reliable milk production.",
    "image_path": "assets/images/breeds/gir.png"
  },
  {
    "id": "breed_011",
    "name": "Tharparkar",
    "species": "Cow",
    "origin": "Tharparkar, Sindh, Pakistan and Rajasthan, India",
    "avg_yield_per_lactation_liters": "1500-2500",
    "avg_fat_percentage": 4.5,
    "description": "A hardy, medium-to-large zebu breed with a white or light-gray coat and prominent hump. Tharparkar cattle are suited to hot, dry, drought-prone environments and can produce useful milk under limited feed availability.",
    "image_path": "assets/images/breeds/tharparkar.png"
  },
  {
    "id": "breed_012",
    "name": "Kankrej",
    "species": "Cow",
    "origin": "Gujarat, India",
    "avg_yield_per_lactation_liters": "1200-1800",
    "avg_fat_percentage": 4.5,
    "description": "A large, powerful zebu breed with a silver-gray to steel-gray coat, lyre-shaped horns, and a prominent hump. It is highly adapted to hot, semi-arid conditions and provides moderate milk production alongside strong draught ability.",
    "image_path": "assets/images/breeds/kankrej.png"
  },
  {
    "id": "breed_013",
    "name": "Rathi",
    "species": "Cow",
    "origin": "Rajasthan, India",
    "avg_yield_per_lactation_liters": "1500-2500",
    "avg_fat_percentage": 4.5,
    "description": "A medium-sized dairy zebu breed with a white or brown coat, often covered in irregular patches. Rathi cattle are well adapted to the hot and dry conditions of northwestern India and are valued for efficient milk production under challenging conditions.",
    "image_path": "assets/images/breeds/rathi.png"
  },
  {
    "id": "breed_014",
    "name": "Hariana",
    "species": "Cow",
    "origin": "Haryana, India",
    "avg_yield_per_lactation_liters": "1000-1600",
    "avg_fat_percentage": 4.5,
    "description": "A white or light-gray zebu breed with a strong frame, prominent hump, and well-developed limbs. It is adapted to hot northern Indian conditions and produces moderate milk while also being valued for agricultural work.",
    "image_path": "assets/images/breeds/hariana.png"
  },
  {
    "id": "breed_015",
    "name": "Deoni",
    "species": "Cow",
    "origin": "Maharashtra, India",
    "avg_yield_per_lactation_liters": "1000-1500",
    "avg_fat_percentage": 4.5,
    "description": "A medium-to-large dual-purpose breed with white, black, or spotted coat patterns and a sturdy body. Deoni cattle tolerate warm climates and are valued for moderate milk production, hardiness, and agricultural utility.",
    "image_path": "assets/images/breeds/deoni.png"
  },
  {
    "id": "breed_016",
    "name": "Nili-Ravi",
    "species": "Buffalo",
    "origin": "Punjab, Pakistan and India",
    "avg_yield_per_lactation_liters": "1800-3000",
    "avg_fat_percentage": 7.0,
    "description": "A large dairy buffalo, usually black with white markings on the forehead, tail switch, and lower legs. It thrives in irrigated and semi-arid South Asian regions when provided with water for cooling and produces rich, high-fat milk.",
    "image_path": "assets/images/breeds/nili_ravi.png"
  },
  {
    "id": "breed_017",
    "name": "Kundi",
    "species": "Buffalo",
    "origin": "Sindh, Pakistan",
    "avg_yield_per_lactation_liters": "1500-2200",
    "avg_fat_percentage": 7.0,
    "description": "A medium-to-large black buffalo known for its tightly curled horns and compact body. Kundi buffaloes are adapted to the hot conditions of Sindh and produce high-fat milk important to traditional dairy farming.",
    "image_path": "assets/images/breeds/kundi.png"
  },
  {
    "id": "breed_018",
    "name": "Murrah",
    "species": "Buffalo",
    "origin": "Haryana and Punjab, India",
    "avg_yield_per_lactation_liters": "1800-3000",
    "avg_fat_percentage": 7.5,
    "description": "A prominent dairy buffalo with a glossy black coat, compact body, and tightly curled spiral horns. Murrah buffaloes adapt well to tropical and subtropical climates with adequate feed and cooling and are renowned for rich, high-fat milk.",
    "image_path": "assets/images/breeds/murrah.png"
  },
  {
    "id": "breed_019",
    "name": "Jaffarabadi",
    "species": "Buffalo",
    "origin": "Gujarat, India",
    "avg_yield_per_lactation_liters": "1800-2800",
    "avg_fat_percentage": 7.5,
    "description": "One of India's largest buffalo breeds, characterized by a massive frame, broad forehead, and heavy drooping horns. It is suited to warm climates and produces substantial quantities of high-fat milk when provided with good nutrition.",
    "image_path": "assets/images/breeds/jaffarabadi.png"
  },
  {
    "id": "breed_020",
    "name": "Surti",
    "species": "Buffalo",
    "origin": "Gujarat, India",
    "avg_yield_per_lactation_liters": "1200-1800",
    "avg_fat_percentage": 7.0,
    "description": "A medium-sized buffalo with a compact body and sickle-shaped horns. Surti buffaloes are well adapted to warm climates and modest farming systems, producing moderately high-fat milk with efficient feed utilization.",
    "image_path": "assets/images/breeds/surti.png"
  },
  {
    "id": "breed_021",
    "name": "Mehsana",
    "species": "Buffalo",
    "origin": "Gujarat, India",
    "avg_yield_per_lactation_liters": "1500-2500",
    "avg_fat_percentage": 7.0,
    "description": "A medium-to-large dairy buffalo, generally black with crescent-shaped horns and a sturdy body. Mehsana buffaloes are suited to hot and semi-arid regions and are valued for persistent lactation and high-fat milk.",
    "image_path": "assets/images/breeds/mehsana.png"
  },
  {
    "id": "breed_022",
    "name": "Bhadawari",
    "species": "Buffalo",
    "origin": "Uttar Pradesh and Madhya Pradesh, India",
    "avg_yield_per_lactation_liters": "800-1500",
    "avg_fat_percentage": 8.0,
    "description": "A medium-sized buffalo with a coppery or brownish-black coat and distinctive sickle-shaped horns. It is adapted to hot, dry environments and is particularly valued for milk with exceptionally high fat content.",
    "image_path": "assets/images/breeds/bhadawari.png"
  },
  {
    "id": "breed_023",
    "name": "Nagar",
    "species": "Buffalo",
    "origin": "Gujarat, India",
    "avg_yield_per_lactation_liters": "1000-1800",
    "avg_fat_percentage": 7.0,
    "description": "A hardy buffalo type found in parts of Gujarat, generally displaying a dark coat and a robust body. It is suited to warm regional conditions and provides moderate milk production with a high fat percentage.",
    "image_path": "assets/images/breeds/nagar_buffalo.png"
  },
  {
    "id": "breed_024",
    "name": "Toda",
    "species": "Buffalo",
    "origin": "Nilgiri Hills, Tamil Nadu, India",
    "avg_yield_per_lactation_liters": "500-900",
    "avg_fat_percentage": 8.0,
    "description": "A distinctive hill buffalo with a compact body, long sweeping horns, and often a gray or dark coat with markings. Toda buffaloes are adapted to the cool, hilly grasslands of the Nilgiris and produce relatively low volumes of very rich milk.",
    "image_path": "assets/images/breeds/toda.png"
  },
  {
    "id": "breed_025",
    "name": "Mediterranean Buffalo",
    "species": "Buffalo",
    "origin": "Italy and the Mediterranean region",
    "avg_yield_per_lactation_liters": "1500-2500",
    "avg_fat_percentage": 8.0,
    "description": "A large, dark-colored buffalo type with a robust build and variable horn shapes. It is adapted to warm Mediterranean and subtropical environments and is especially valued for rich milk used in mozzarella and other dairy products.",
    "image_path": "assets/images/breeds/mediterranean_buffalo.png"
  },
  {
    "id": "breed_026",
    "name": "Egyptian Buffalo",
    "species": "Buffalo",
    "origin": "Egypt",
    "avg_yield_per_lactation_liters": "1200-2000",
    "avg_fat_percentage": 7.0,
    "description": "A large, dark buffalo commonly raised along the Nile Valley and Delta. It is well adapted to hot conditions when provided with water and shade and produces milk with high fat and total solids.",
    "image_path": "assets/images/breeds/egyptian_buffalo.png"
  },
  {
    "id": "breed_027",
    "name": "Carabao",
    "species": "Buffalo",
    "origin": "Philippines",
    "avg_yield_per_lactation_liters": "600-1200",
    "avg_fat_percentage": 7.0,
    "description": "A swamp buffalo type with a broad body, large curved horns, and a strong, sturdy frame. It is well adapted to hot, humid, tropical environments and produces moderate milk quantities with high fat content.",
    "image_path": "assets/images/breeds/carabao.png"
  },
  {
    "id": "breed_028",
    "name": "Australian Friesian Sahiwal",
    "species": "Cow",
    "origin": "Australia",
    "avg_yield_per_lactation_liters": "2500-4500",
    "avg_fat_percentage": 4.2,
    "description": "A composite breed developed by combining the milk production of Friesian cattle with the heat tolerance of Sahiwal cattle. It has a generally dark or pied coat and performs well in hot, humid environments while maintaining useful dairy yields.",
    "image_path": "assets/images/breeds/australian_friesian_sahiwal.png"
  },
  {
    "id": "breed_029",
    "name": "Montbéliarde",
    "species": "Cow",
    "origin": "France",
    "avg_yield_per_lactation_liters": "6000-8000",
    "avg_fat_percentage": 3.9,
    "description": "A large red-and-white dairy breed with a strong frame, excellent legs, and a robust constitution. It adapts well to temperate and mountainous climates and is valued for milk rich in protein, particularly for cheese production.",
    "image_path": "assets/images/breeds/montbeliarde.png"
  },
  {
    "id": "breed_030",
    "name": "Normande",
    "species": "Cow",
    "origin": "Normandy, France",
    "avg_yield_per_lactation_liters": "5500-7000",
    "avg_fat_percentage": 4.2,
    "description": "A medium-to-large breed with a distinctive white coat covered in red or brown patches and a broad, muscular body. Normande cows perform well in temperate grazing systems and produce milk with excellent fat and protein suitable for cheese and butter.",
    "image_path": "assets/images/breeds/normande.png"
  },
  {
    "id": "breed_031",
    "name": "Simmental",
    "species": "Cow",
    "origin": "Switzerland",
    "avg_yield_per_lactation_liters": "5500-8000",
    "avg_fat_percentage": 4.0,
    "description": "A large breed typically displaying red-and-white or fawn-and-white markings with a strong, muscular build. Simmental cattle adapt well to temperate climates and provide good milk yields with balanced fat and protein levels.",
    "image_path": "assets/images/breeds/simmental.png"
  },
  {
    "id": "breed_032",
    "name": "Fleckvieh",
    "species": "Cow",
    "origin": "Germany and Austria",
    "avg_yield_per_lactation_liters": "6500-8500",
    "avg_fat_percentage": 4.1,
    "description": "A dual-purpose breed with red-and-white markings, a large frame, and strong muscular development. It performs well in temperate and alpine regions and is valued for dependable milk production, good milk solids, and robust health.",
    "image_path": "assets/images/breeds/fleckvieh.png"
  },
  {
    "id": "breed_033",
    "name": "Danish Red",
    "species": "Cow",
    "origin": "Denmark",
    "avg_yield_per_lactation_liters": "7000-9000",
    "avg_fat_percentage": 4.2,
    "description": "A medium-to-large breed with a uniform red coat, strong body, and good udder conformation. Danish Red cattle perform best in temperate climates and are valued for efficient milk production and favorable milk composition.",
    "image_path": "assets/images/breeds/danish_red.png"
  },
  {
    "id": "breed_034",
    "name": "Dutch Belted",
    "species": "Cow",
    "origin": "Netherlands",
    "avg_yield_per_lactation_liters": "4000-6000",
    "avg_fat_percentage": 4.0,
    "description": "A distinctive medium-sized breed with a black body and a broad white belt around its middle. It is hardy and efficient on pasture in temperate climates, producing moderate milk yields with good fat content.",
    "image_path": "assets/images/breeds/dutch_belted.png"
  },
  {
    "id": "breed_035",
    "name": "Kerry",
    "species": "Cow",
    "origin": "Ireland",
    "avg_yield_per_lactation_liters": "2500-4000",
    "avg_fat_percentage": 4.2,
    "description": "A small, fine-boned dairy breed with a predominantly black coat and a refined appearance. Kerry cattle are hardy and well suited to cool, wet climates and produce moderately low volumes of milk with relatively high solids.",
    "image_path": "assets/images/breeds/kerry.png"
  },
  {
    "id": "breed_036",
    "name": "Devon",
    "species": "Cow",
    "origin": "England",
    "avg_yield_per_lactation_liters": "2500-4000",
    "avg_fat_percentage": 4.0,
    "description": "A medium-sized breed with a rich red coat, strong limbs, and a robust body. Devon cattle are adaptable to pasture-based systems and temperate climates, producing moderate milk while also being valued for beef qualities.",
    "image_path": "assets/images/breeds/devon.png"
  },
  {
    "id": "breed_037",
    "name": "Aussie Red",
    "species": "Cow",
    "origin": "Australia",
    "avg_yield_per_lactation_liters": "6000-8000",
    "avg_fat_percentage": 4.0,
    "description": "A red-coated dairy breed developed for efficient production in Australian conditions. It is suited to temperate and warm regions with appropriate management and is valued for productive lactation and functional conformation.",
    "image_path": "assets/images/breeds/aussie_red.png"
  },
  {
    "id": "breed_038",
    "name": "Illawarra",
    "species": "Cow",
    "origin": "New South Wales, Australia",
    "avg_yield_per_lactation_liters": "5500-7500",
    "avg_fat_percentage": 4.0,
    "description": "A red or roan dairy breed with a strong frame, good feet, and a durable constitution. Illawarra cattle adapt to varied Australian climates and are valued for consistent milk production, fertility, and longevity.",
    "image_path": "assets/images/breeds/illawarra.png"
  },
  {
    "id": "breed_039",
    "name": "Holstein Red and White",
    "species": "Cow",
    "origin": "Netherlands and Germany",
    "avg_yield_per_lactation_liters": "7000-11000",
    "avg_fat_percentage": 3.8,
    "description": "A red-and-white color variant of the Holstein breed with the same large frame and dairy conformation. It is suited to well-managed dairy systems and can produce high milk volumes, particularly in temperate or climate-controlled environments.",
    "image_path": "assets/images/breeds/holstein_red_white.png"
  },
  {
    "id": "breed_040",
    "name": "Agerolese",
    "species": "Cow",
    "origin": "Campania, Italy",
    "avg_yield_per_lactation_liters": "3000-4500",
    "avg_fat_percentage": 3.8,
    "description": "A medium-sized Italian dairy breed with a dark or black coat and a well-proportioned body. It is suited to hilly Mediterranean environments and produces moderate milk quantities used in regional dairy products.",
    "image_path": "assets/images/breeds/agerolese.png"
  },
  {
    "id": "breed_041",
    "name": "Modenese",
    "species": "Cow",
    "origin": "Emilia-Romagna, Italy",
    "avg_yield_per_lactation_liters": "3000-4500",
    "avg_fat_percentage": 3.8,
    "description": "A medium-sized Italian breed with a white coat and distinctive dark pigmentation around the head and shoulders. It is adapted to temperate agricultural environments and provides moderate milk production alongside traditional dual-purpose utility.",
    "image_path": "assets/images/breeds/modenese.png"
  },
  {
    "id": "breed_042",
    "name": "Tarentaise",
    "species": "Cow",
    "origin": "French Alps, France",
    "avg_yield_per_lactation_liters": "4000-5500",
    "avg_fat_percentage": 3.8,
    "description": "A medium-sized reddish-brown mountain breed with a dark muzzle, strong legs, and excellent walking ability. It is highly adapted to alpine terrain and cold climates and produces moderate milk yields with good solids for cheese production.",
    "image_path": "assets/images/breeds/tarentaise.png"
  },
  {
    "id": "breed_043",
    "name": "Abondance",
    "species": "Cow",
    "origin": "Haute-Savoie, France",
    "avg_yield_per_lactation_liters": "5000-6500",
    "avg_fat_percentage": 3.8,
    "description": "A medium-sized red-pied breed with a white body, red markings, and a dark eye area. Abondance cattle are well adapted to mountainous climates and produce milk particularly valued for traditional cheese making.",
    "image_path": "assets/images/breeds/abondance.png"
  },
  {
    "id": "breed_044",
    "name": "Maine-Anjou",
    "species": "Cow",
    "origin": "France",
    "avg_yield_per_lactation_liters": "3000-4500",
    "avg_fat_percentage": 3.8,
    "description": "A large red-and-white breed with a powerful frame and strong muscling. It is primarily dual-purpose rather than specialized for dairy production, but can provide moderate milk yields in temperate farming systems.",
    "image_path": "assets/images/breeds/maine_anjou.png"
  },
  {
    "id": "breed_045",
    "name": "Norwegian Red",
    "species": "Cow",
    "origin": "Norway",
    "avg_yield_per_lactation_liters": "7000-9000",
    "avg_fat_percentage": 4.2,
    "description": "A modern Norwegian dairy breed with red, white, or black-and-white color patterns and a sturdy body. It is suited to cool and temperate climates and is selected for milk production, fertility, health, and functional longevity.",
    "image_path": "assets/images/breeds/norwegian_red.png"
  },
  {
    "id": "breed_046",
    "name": "Swedish Red",
    "species": "Cow",
    "origin": "Sweden",
    "avg_yield_per_lactation_liters": "7000-9000",
    "avg_fat_percentage": 4.2,
    "description": "A red-coated dairy breed with a medium-to-large frame and strong functional traits. It performs well in cool and temperate climates and is valued for milk yield, fertility, udder health, and longevity.",
    "image_path": "assets/images/breeds/swedish_red.png"
  },
  {
    "id": "breed_047",
    "name": "Fleckvieh-Simmental",
    "species": "Cow",
    "origin": "Central Europe",
    "avg_yield_per_lactation_liters": "5500-8000",
    "avg_fat_percentage": 4.0,
    "description": "A red-and-white dual-purpose cattle type with a large frame, strong legs, and muscular body. It adapts well to temperate and mountainous conditions and offers dependable milk production with balanced milk solids.",
    "image_path": "assets/images/breeds/fleckvieh_simmental.png"
  },
  {
    "id": "breed_048",
    "name": "Bazadaise",
    "species": "Cow",
    "origin": "Gironde, France",
    "avg_yield_per_lactation_liters": "2000-3500",
    "avg_fat_percentage": 4.0,
    "description": "A gray-coated French breed with a sturdy body and strong limbs. It is primarily a beef breed but can produce moderate milk for calf rearing and is adapted to temperate pasture-based systems.",
    "image_path": "assets/images/breeds/bazadaise.png"
  },
  {
    "id": "breed_049",
    "name": "Murnau-Werdenfels",
    "species": "Cow",
    "origin": "Bavaria, Germany",
    "avg_yield_per_lactation_liters": "3500-5000",
    "avg_fat_percentage": 4.0,
    "description": "A medium-sized alpine breed with a dark reddish-brown to black coat and a strong, compact frame. It is well adapted to mountainous terrain and temperate climates and provides moderate milk production with useful solids.",
    "image_path": "assets/images/breeds/murnau_werdenfels.png"
  },
  {
    "id": "breed_050",
    "name": "Pinzgauer",
    "species": "Cow",
    "origin": "Austria",
    "avg_yield_per_lactation_liters": "3500-5000",
    "avg_fat_percentage": 3.9,
    "description": "A distinctive chestnut-red breed with a broad white stripe along the back and underside. It is hardy in mountainous and temperate environments and produces moderate milk while also serving as a dual-purpose breed.",
    "image_path": "assets/images/breeds/pinzgauer.png"
  },
  {
    "id": "breed_051",
    "name": "Vorderwald",
    "species": "Cow",
    "origin": "Black Forest, Germany",
    "avg_yield_per_lactation_liters": "4500-6500",
    "avg_fat_percentage": 4.0,
    "description": "A medium-sized, sturdy breed with brown or red-pied coloring and good walking ability. It is well suited to hilly and temperate pasture systems and produces moderate-to-good milk yields with useful solids.",
    "image_path": "assets/images/breeds/vorderwald.png"
  },
  {
    "id": "breed_052",
    "name": "Angeln",
    "species": "Cow",
    "origin": "Schleswig-Holstein, Germany",
    "avg_yield_per_lactation_liters": "6000-8000",
    "avg_fat_percentage": 4.5,
    "description": "A red-coated dairy breed with a medium-sized body and strong dairy conformation. Angeln cattle perform well in cool, temperate climates and are known for milk with relatively high fat content.",
    "image_path": "assets/images/breeds/angeln.png"
  },
  {
    "id": "breed_053",
    "name": "Dutch Friesian",
    "species": "Cow",
    "origin": "Netherlands",
    "avg_yield_per_lactation_liters": "6000-8500",
    "avg_fat_percentage": 4.0,
    "description": "A traditional black-and-white or red-and-white Dutch dairy breed with a strong, angular frame. It performs well in temperate pasture-based systems and provides dependable milk production with balanced fat and protein.",
    "image_path": "assets/images/breeds/dutch_friesian.png"
  },
  {
    "id": "breed_054",
    "name": "Kostroma",
    "species": "Cow",
    "origin": "Russia",
    "avg_yield_per_lactation_liters": "5000-7000",
    "avg_fat_percentage": 3.9,
    "description": "A large, sturdy breed with a gray-brown or brown coat and a robust constitution. It is adapted to cool continental climates and is valued for moderate-to-high milk yields, longevity, and dual-purpose performance.",
    "image_path": "assets/images/breeds/kostroma.png"
  },
  {
    "id": "breed_055",
    "name": "Yaroslavl",
    "species": "Cow",
    "origin": "Yaroslavl Region, Russia",
    "avg_yield_per_lactation_liters": "4000-6000",
    "avg_fat_percentage": 4.2,
    "description": "A medium-sized dairy breed usually black with white markings on the head, belly, and legs. It is well adapted to cool climates and is valued for milk with relatively high fat content and good processing quality.",
    "image_path": "assets/images/breeds/yaroslavl.png"
  },
  {
    "id": "breed_056",
    "name": "Kholmogory",
    "species": "Cow",
    "origin": "Arkhangelsk Region, Russia",
    "avg_yield_per_lactation_liters": "4000-6000",
    "avg_fat_percentage": 3.8,
    "description": "A large, hardy breed with black-and-white or red-and-white markings and a strong body. Kholmogory cattle are adapted to cold northern climates and provide dependable milk production under challenging environmental conditions.",
    "image_path": "assets/images/breeds/kholmogory.png"
  },
  {
    "id": "breed_057",
    "name": "Tagil",
    "species": "Cow",
    "origin": "Ural Region, Russia",
    "avg_yield_per_lactation_liters": "3500-5000",
    "avg_fat_percentage": 4.0,
    "description": "A medium-sized breed with black, red, or pied coloring and a strong, compact frame. It is adapted to cool continental climates and produces moderate milk yields with useful fat content.",
    "image_path": "assets/images/breeds/tagil.png"
  },
  {
    "id": "breed_058",
    "name": "Auliekol",
    "species": "Cow",
    "origin": "Kazakhstan",
    "avg_yield_per_lactation_liters": "2500-4000",
    "avg_fat_percentage": 3.8,
    "description": "A hardy composite cattle breed with a light or white coat and a strong body. It is adapted to continental climates with temperature extremes and provides moderate milk production alongside good beef characteristics.",
    "image_path": "assets/images/breeds/auliekol.png"
  },
  {
    "id": "breed_059",
    "name": "Kazakh Whiteheaded",
    "species": "Cow",
    "origin": "Kazakhstan",
    "avg_yield_per_lactation_liters": "1800-3000",
    "avg_fat_percentage": 3.8,
    "description": "A hardy breed with a red or reddish-brown body and a distinctive white head and underside. It is adapted to dry continental climates and is primarily dual-purpose, producing moderate milk for calf rearing.",
    "image_path": "assets/images/breeds/kazakh_whiteheaded.png"
  },
  {
    "id": "breed_060",
    "name": "Yakutian",
    "species": "Cow",
    "origin": "Sakha Republic, Russia",
    "avg_yield_per_lactation_liters": "1000-2000",
    "avg_fat_percentage": 5.0,
    "description": "A small, compact cattle breed with a thick coat that provides exceptional protection against severe cold. Yakutian cattle are highly adapted to subarctic climates and produce modest milk quantities with relatively high fat content.",
    "image_path": "assets/images/breeds/yakutian.png"
  },
  {
    "id": "breed_061",
    "name": "Bazadais Dairy Type",
    "species": "Cow",
    "origin": "France",
    "avg_yield_per_lactation_liters": "2000-3500",
    "avg_fat_percentage": 4.0,
    "description": "A regional cattle type with a gray coat, strong limbs, and a robust body. It is adapted to temperate pasture environments and provides modest milk production, primarily supporting calf growth rather than intensive dairy farming.",
    "image_path": "assets/images/breeds/bazadais_dairy_type.png"
  },
  {
    "id": "breed_062",
    "name": "Manteuffel",
    "species": "Cow",
    "origin": "Germany",
    "avg_yield_per_lactation_liters": "4000-6000",
    "avg_fat_percentage": 4.0,
    "description": "A traditional European cattle type with a sturdy frame and varied coat coloration. It is suited to temperate climates and mixed farming systems, providing moderate milk production and useful hardiness.",
    "image_path": "assets/images/breeds/manteuffel.png"
  },
  {
    "id": "breed_063",
    "name": "Brahman Dairy Cross",
    "species": "Cow",
    "origin": "United States",
    "avg_yield_per_lactation_liters": "2500-4500",
    "avg_fat_percentage": 4.0,
    "description": "A dairy-oriented cross involving heat-tolerant Brahman genetics and specialized dairy cattle. It generally has a loose skin, prominent hump, and strong heat tolerance, making it suitable for hot climates where pure temperate dairy breeds may struggle.",
    "image_path": "assets/images/breeds/brahman_dairy_cross.png"
  },
  {
    "id": "breed_064",
    "name": "Brahman",
    "species": "Cow",
    "origin": "United States",
    "avg_yield_per_lactation_liters": "800-1500",
    "avg_fat_percentage": 4.5,
    "description": "A heat-tolerant zebu breed with a prominent hump, loose skin, large ears, and a short coat. It thrives in hot, humid, and challenging tropical environments, although it is primarily a beef breed with relatively low milk production.",
    "image_path": "assets/images/breeds/brahman.png"
  },
  {
    "id": "breed_065",
    "name": "Nelore",
    "species": "Cow",
    "origin": "Brazil",
    "avg_yield_per_lactation_liters": "500-1000",
    "avg_fat_percentage": 4.5,
    "description": "A white or light-gray zebu breed with a prominent hump, loose skin, and large drooping ears. It is highly adapted to hot tropical climates and is primarily used for beef production, with milk generally intended for calf rearing.",
    "image_path": "assets/images/breeds/nelore.png"
  },
  {
    "id": "breed_066",
    "name": "Guzerat",
    "species": "Cow",
    "origin": "Gujarat, India and Brazil",
    "avg_yield_per_lactation_liters": "1200-2200",
    "avg_fat_percentage": 4.5,
    "description": "A large zebu breed with a distinctive dished forehead, long horns, and a gray or silver coat. It is highly adapted to hot, dry conditions and is valued for hardiness, though milk yields are moderate compared with specialized dairy breeds.",
    "image_path": "assets/images/breeds/guzerat.png"
  },
  {
    "id": "breed_067",
    "name": "Indubrasil",
    "species": "Cow",
    "origin": "Brazil",
    "avg_yield_per_lactation_liters": "1000-2000",
    "avg_fat_percentage": 4.5,
    "description": "A large zebu breed with long, pendulous ears, a prominent hump, and a white or gray coat. It is adapted to hot tropical environments and is primarily dual-purpose, providing moderate milk production alongside beef utility.",
    "image_path": "assets/images/breeds/indubrasil.png"
  },
  {
    "id": "breed_068",
    "name": "Sindi",
    "species": "Cow",
    "origin": "Sindh, Pakistan",
    "avg_yield_per_lactation_liters": "1200-2200",
    "avg_fat_percentage": 4.5,
    "description": "A small-to-medium reddish-brown zebu breed with a compact body and good heat tolerance. Sindi cattle are well adapted to hot, dry regions and provide moderate milk production under low-input management.",
    "image_path": "assets/images/breeds/sindi.png"
  },
  {
    "id": "breed_069",
    "name": "Ongole",
    "species": "Cow",
    "origin": "Andhra Pradesh, India",
    "avg_yield_per_lactation_liters": "800-1500",
    "avg_fat_percentage": 4.5,
    "description": "A large, powerful white or gray zebu breed with a prominent hump and strong limbs. Ongole cattle are highly adapted to hot climates and are primarily valued for draught and beef qualities, with limited milk production.",
    "image_path": "assets/images/breeds/ongole.png"
  },
  {
    "id": "breed_070",
    "name": "Kangayam",
    "species": "Cow",
    "origin": "Tamil Nadu, India",
    "avg_yield_per_lactation_liters": "500-1000",
    "avg_fat_percentage": 4.5,
    "description": "A compact, muscular zebu breed with a gray or white coat, dark extremities, and strong horns. It is exceptionally adapted to hot, dry conditions and is primarily used for draught work, producing relatively low milk yields.",
    "image_path": "assets/images/breeds/kangayam.png"
  },
  {
    "id": "breed_071",
    "name": "Hallikar",
    "species": "Cow",
    "origin": "Karnataka, India",
    "avg_yield_per_lactation_liters": "400-800",
    "avg_fat_percentage": 4.5,
    "description": "A medium-sized gray zebu breed with a strong body, prominent hump, and well-developed horns. It is highly adapted to hot, dry environments and is mainly valued for draught ability rather than dairy production.",
    "image_path": "assets/images/breeds/hallikar.png"
  },
  {
    "id": "breed_072",
    "name": "Amrit Mahal",
    "species": "Cow",
    "origin": "Karnataka, India",
    "avg_yield_per_lactation_liters": "400-800",
    "avg_fat_percentage": 4.5,
    "description": "A strong, compact zebu breed with a gray or white coat and powerful limbs. It is well adapted to hot, dry conditions and is primarily known for draught performance, with low milk production.",
    "image_path": "assets/images/breeds/amrit_mahal.png"
  },
  {
    "id": "breed_073",
    "name": "Ongole Dairy Type",
    "species": "Cow",
    "origin": "Andhra Pradesh, India",
    "avg_yield_per_lactation_liters": "800-1400",
    "avg_fat_percentage": 4.5,
    "description": "A hardy white or gray zebu cattle type with a large frame, strong hump, and durable constitution. It tolerates hot climates well and can provide modest milk production, though it is primarily maintained for beef and draught purposes.",
    "image_path": "assets/images/breeds/ongole_dairy_type.png"
  },
  {
    "id": "breed_074",
    "name": "Vechur",
    "species": "Cow",
    "origin": "Kerala, India",
    "avg_yield_per_lactation_liters": "500-1000",
    "avg_fat_percentage": 4.5,
    "description": "One of the world's smallest cattle breeds, with a compact body, short stature, and varied coat colors. Vechur cattle are highly adapted to Kerala's humid tropical climate and produce small quantities of milk suited to low-input household farming.",
    "image_path": "assets/images/breeds/vechur.png"
  },
  {
    "id": "breed_075",
    "name": "Punganur",
    "species": "Cow",
    "origin": "Andhra Pradesh, India",
    "avg_yield_per_lactation_liters": "500-1000",
    "avg_fat_percentage": 5.0,
    "description": "A very small zebu breed with a compact frame, short legs, and a varied coat ranging from white to gray or brown. It is adapted to hot, dry conditions and produces modest milk with relatively high fat content.",
    "image_path": "assets/images/breeds/punganur.png"
  },
  {
    "id": "breed_076",
    "name": "Malnad Gidda",
    "species": "Cow",
    "origin": "Karnataka, India",
    "avg_yield_per_lactation_liters": "500-1000",
    "avg_fat_percentage": 4.5,
    "description": "A small, hardy zebu breed with a compact body and usually dark or brown coloring. It is well adapted to humid, hilly environments and produces modest milk under low-input conditions while maintaining strong disease resistance.",
    "image_path": "assets/images/breeds/malnad_gidda.png"
  },
  {
    "id": "breed_077",
    "name": "Kherigarh",
    "species": "Cow",
    "origin": "Uttar Pradesh, India",
    "avg_yield_per_lactation_liters": "600-1200",
    "avg_fat_percentage": 4.5,
    "description": "A small-to-medium white or gray zebu breed with a compact body and strong limbs. It is adapted to hot, dry regions and is valued for hardiness and draught ability, with modest milk production.",
    "image_path": "assets/images/breeds/kherigarh.png"
  },
  {
    "id": "breed_078",
    "name": "Mewati",
    "species": "Cow",
    "origin": "Rajasthan and Haryana, India",
    "avg_yield_per_lactation_liters": "800-1400",
    "avg_fat_percentage": 4.5,
    "description": "A medium-sized white or gray zebu breed with a strong frame and prominent hump. It is adapted to hot, semi-arid conditions and provides moderate milk production alongside useful draught ability.",
    "image_path": "assets/images/breeds/mewati.png"
  },
  {
    "id": "breed_079",
    "name": "Nimari",
    "species": "Cow",
    "origin": "Madhya Pradesh, India",
    "avg_yield_per_lactation_liters": "800-1400",
    "avg_fat_percentage": 4.5,
    "description": "A medium-sized red-and-white or brown-and-white zebu breed with a sturdy body and strong limbs. It is adapted to warm, dry climates and produces modest milk while also being valued for draught work.",
    "image_path": "assets/images/breeds/nimari.png"
  },
  {
    "id": "breed_080",
    "name": "Dangi",
    "species": "Cow",
    "origin": "Maharashtra and Gujarat, India",
    "avg_yield_per_lactation_liters": "500-1000",
    "avg_fat_percentage": 4.5,
    "description": "A medium-sized, hardy breed with a white coat featuring red or black patches and a strong body. Dangi cattle are particularly suited to heavy rainfall and hilly terrain and are valued primarily for draught ability with low-to-moderate milk production.",
    "image_path": "assets/images/breeds/dangi.png"
  },
  {
    "id": "breed_081",
    "name": "Khillari",
    "species": "Cow",
    "origin": "Maharashtra and Karnataka, India",
    "avg_yield_per_lactation_liters": "400-800",
    "avg_fat_percentage": 4.5,
    "description": "A compact, muscular zebu breed with a white or gray coat, strong horns, and powerful legs. It is well adapted to hot, dry regions and is primarily valued for fast, efficient draught work rather than milk production.",
    "image_path": "assets/images/breeds/khillari.png"
  },
  {
    "id": "breed_082",
    "name": "Bargur",
    "species": "Cow",
    "origin": "Tamil Nadu, India",
    "avg_yield_per_lactation_liters": "500-900",
    "avg_fat_percentage": 4.5,
    "description": "A compact, agile indigenous breed, often brown or white with distinctive patches and strong limbs. Bargur cattle are highly adapted to hilly terrain and hot conditions, although their primary value is hardiness and draught ability rather than high milk yield.",
    "image_path": "assets/images/breeds/bargur.png"
  },
  {
    "id": "breed_083",
    "name": "Umblachery",
    "species": "Cow",
    "origin": "Tamil Nadu, India",
    "avg_yield_per_lactation_liters": "500-1000",
    "avg_fat_percentage": 4.5,
    "description": "A small-to-medium zebu breed with a gray or white body and dark extremities. It is adapted to hot, humid delta regions and is primarily valued for draught work and hardiness, with limited milk production.",
    "image_path": "assets/images/breeds/umblachery.png"
  },
  {
    "id": "breed_084",
    "name": "Pulikulam",
    "species": "Cow",
    "origin": "Tamil Nadu, India",
    "avg_yield_per_lactation_liters": "400-800",
    "avg_fat_percentage": 4.5,
    "description": "A hardy, medium-sized zebu breed with a gray or white coat and strong, agile limbs. It is adapted to hot, dry environments and is primarily used for draught and traditional livestock activities rather than dairy production.",
    "image_path": "assets/images/breeds/pulikulam.png"
  },
  {
    "id": "breed_085",
    "name": "Kasaragod Dwarf",
    "species": "Cow",
    "origin": "Kerala, India",
    "avg_yield_per_lactation_liters": "400-800",
    "avg_fat_percentage": 4.5,
    "description": "A small indigenous cattle breed with a compact body and varied coat colors. It is well adapted to humid tropical conditions and low-input management, producing modest milk quantities for household use.",
    "image_path": "assets/images/breeds/kasaragod_dwarf.png"
  },
  {
    "id": "breed_086",
    "name": "Banni",
    "species": "Buffalo",
    "origin": "Kutch, Gujarat, India",
    "avg_yield_per_lactation_liters": "1500-2500",
    "avg_fat_percentage": 7.0,
    "description": "A hardy black buffalo from the Banni grasslands, known for its strong body and ability to graze in semi-arid environments. It tolerates heat and limited resources well and produces rich milk under pastoral management.",
    "image_path": "assets/images/breeds/banni.png"
  },
  {
    "id": "breed_087",
    "name": "Marathwadi",
    "species": "Buffalo",
    "origin": "Maharashtra, India",
    "avg_yield_per_lactation_liters": "1000-1800",
    "avg_fat_percentage": 7.0,
    "description": "A medium-sized black buffalo with a sturdy frame and moderate horn development. It is adapted to the hot, dry Deccan region and provides useful milk production with high fat content under local management systems.",
    "image_path": "assets/images/breeds/marathwadi.png"
  },
  {
    "id": "breed_088",
    "name": "Pandharpuri",
    "species": "Buffalo",
    "origin": "Maharashtra, India",
    "avg_yield_per_lactation_liters": "1200-2000",
    "avg_fat_percentage": 7.0,
    "description": "A distinctive black buffalo with very long, sword-shaped horns that extend backward and outward. It is adapted to warm, semi-arid conditions and produces moderately high-fat milk valued by local dairy farmers.",
    "image_path": "assets/images/breeds/pandharpuri.png"
  },
  {
    "id": "breed_089",
    "name": "Nili",
    "species": "Buffalo",
    "origin": "Punjab, Pakistan and India",
    "avg_yield_per_lactation_liters": "1500-2500",
    "avg_fat_percentage": 7.0,
    "description": "A black dairy buffalo type with white markings often seen on the forehead, legs, and tail. It is adapted to the warm plains of Punjab and is valued for good milk production with rich fat content.",
    "image_path": "assets/images/breeds/nili.png"
  },
  {
    "id": "breed_090",
    "name": "Ravi",
    "species": "Buffalo",
    "origin": "Punjab, Pakistan and India",
    "avg_yield_per_lactation_liters": "1500-2500",
    "avg_fat_percentage": 7.0,
    "description": "A black buffalo type associated with the Ravi River region, generally showing a robust body and high dairy potential. It is suited to warm South Asian conditions with adequate water and feed and produces rich, high-fat milk.",
    "image_path": "assets/images/breeds/ravi.png"
  },
  {
    "id": "breed_091",
    "name": "Manda",
    "species": "Buffalo",
    "origin": "Odisha, India",
    "avg_yield_per_lactation_liters": "500-1000",
    "avg_fat_percentage": 7.0,
    "description": "A small-to-medium buffalo breed with a compact body and dark coat. It is adapted to warm, humid, and low-input environments and produces modest milk quantities with high fat content.",
    "image_path": "assets/images/breeds/manda.png"
  },
  {
    "id": "breed_092",
    "name": "Kalahandi",
    "species": "Buffalo",
    "origin": "Odisha, India",
    "avg_yield_per_lactation_liters": "500-1000",
    "avg_fat_percentage": 7.0,
    "description": "A hardy indigenous buffalo type with a dark coat and sturdy body. It is adapted to warm, humid conditions and traditional low-input farming systems, producing modest but rich milk.",
    "image_path": "assets/images/breeds/kalahandi.png"
  },
  {
    "id": "breed_093",
    "name": "Toda Buffalo",
    "species": "Buffalo",
    "origin": "Nilgiri Hills, Tamil Nadu, India",
    "avg_yield_per_lactation_liters": "500-900",
    "avg_fat_percentage": 8.0,
    "description": "A distinctive hill buffalo with a compact body, long sweeping horns, and a dark or gray coat. Toda buffaloes are adapted to the cool, hilly grasslands of the Nilgiris and produce relatively low volumes of very rich milk.",
    "image_path": "assets/images/breeds/toda_buffalo.png"
  },
  {
    "id": "breed_094",
    "name": "Bubalus Bubalis Swamp Buffalo",
    "species": "Buffalo",
    "origin": "Southeast Asia",
    "avg_yield_per_lactation_liters": "400-1000",
    "avg_fat_percentage": 7.0,
    "description": "A large, powerful swamp buffalo type with broad horns, a sturdy body, and strong legs. It is highly adapted to hot, humid environments and wetland farming, but generally produces lower milk yields than specialized river buffalo breeds.",
    "image_path": "assets/images/breeds/swamp_buffalo.png"
  },
  {
    "id": "breed_095",
    "name": "Thai River Buffalo",
    "species": "Buffalo",
    "origin": "Thailand",
    "avg_yield_per_lactation_liters": "600-1200",
    "avg_fat_percentage": 7.0,
    "description": "A dark-colored buffalo type with a strong body and broad horns, traditionally raised in Thai agricultural systems. It is well adapted to tropical heat and wet conditions and produces modest milk quantities, mainly supporting calf rearing.",
    "image_path": "assets/images/breeds/thai_river_buffalo.png"
  },
  {
    "id": "breed_096",
    "name": "Philippine River Buffalo",
    "species": "Buffalo",
    "origin": "Philippines",
    "avg_yield_per_lactation_liters": "500-1200",
    "avg_fat_percentage": 7.0,
    "description": "A river buffalo type with a sturdy frame, dark coat, and strong horns, found in tropical farming regions. It adapts to hot and humid climates and produces modest milk yields with rich fat content.",
    "image_path": "assets/images/breeds/philippine_river_buffalo.png"
  },
  {
    "id": "breed_097",
    "name": "Italian Mediterranean Buffalo",
    "species": "Buffalo",
    "origin": "Italy",
    "avg_yield_per_lactation_liters": "1800-2800",
    "avg_fat_percentage": 8.0,
    "description": "A specialized dairy buffalo with a large dark body, strong limbs, and well-developed udder. It thrives in warm Mediterranean climates and is renowned for producing high-fat milk used in mozzarella and other premium dairy products.",
    "image_path": "assets/images/breeds/italian_mediterranean_buffalo.png"
  },
  {
    "id": "breed_098",
    "name": "Bulgarian Murrah",
    "species": "Buffalo",
    "origin": "Bulgaria",
    "avg_yield_per_lactation_liters": "1800-2800",
    "avg_fat_percentage": 7.5,
    "description": "A dairy buffalo population developed from Murrah genetics and local buffaloes, generally showing a black coat and compact, strong body. It adapts well to temperate and warm climates and produces high-fat milk with good dairy value.",
    "image_path": "assets/images/breeds/bulgarian_murrah.png"
  },
  {
    "id": "breed_099",
    "name": "Romanian Buffalo",
    "species": "Buffalo",
    "origin": "Romania",
    "avg_yield_per_lactation_liters": "1000-1800",
    "avg_fat_percentage": 7.5,
    "description": "A large, dark-colored buffalo type with a robust frame and strong limbs. It is adapted to temperate continental climates and produces moderate milk yields with high fat and total solids.",
    "image_path": "assets/images/breeds/romanian_buffalo.png"
  },
  {
    "id": "breed_100",
    "name": "Hungarian Buffalo",
    "species": "Buffalo",
    "origin": "Hungary",
    "avg_yield_per_lactation_liters": "800-1500",
    "avg_fat_percentage": 7.0,
    "description": "A sturdy, dark buffalo type with strong horns and a compact-to-large body. It is adapted to temperate continental climates and is primarily maintained for traditional farming and meat, with modest milk production.",
    "image_path": "assets/images/breeds/hungarian_buffalo.png"
  },
  {
    "id": "breed_101",
    "name": "Caucasian Buffalo",
    "species": "Buffalo",
    "origin": "Caucasus Region",
    "avg_yield_per_lactation_liters": "800-1500",
    "avg_fat_percentage": 7.0,
    "description": "A hardy dark-colored buffalo type with a strong body and durable limbs. It is adapted to warm and temperate mountainous conditions and provides modest milk production with high fat content.",
    "image_path": "assets/images/breeds/caucasian_buffalo.png"
  },
  {
    "id": "breed_102",
    "name": "Anatolian Buffalo",
    "species": "Buffalo",
    "origin": "Turkey",
    "avg_yield_per_lactation_liters": "800-1500",
    "avg_fat_percentage": 7.0,
    "description": "A dark-colored buffalo type with a sturdy frame, strong horns, and good walking ability. It is adapted to warm and temperate Anatolian climates and produces modest quantities of rich milk under traditional management.",
    "image_path": "assets/images/breeds/anatolian_buffalo.png"
  },
  {
    "id": "breed_103",
    "name": "Iraqi Buffalo",
    "species": "Buffalo",
    "origin": "Iraq",
    "avg_yield_per_lactation_liters": "1000-1800",
    "avg_fat_percentage": 7.0,
    "description": "A large, dark buffalo type traditionally raised in the marshlands and river regions of Iraq. It is adapted to hot climates when provided with water and shade and produces moderately rich milk.",
    "image_path": "assets/images/breeds/iraqi_buffalo.png"
  },
  {
    "id": "breed_104",
    "name": "Iranian Buffalo",
    "species": "Buffalo",
    "origin": "Iran",
    "avg_yield_per_lactation_liters": "1000-1800",
    "avg_fat_percentage": 7.0,
    "description": "A sturdy, dark-colored buffalo type raised in various Iranian regions. It is adapted to warm and semi-arid conditions with sufficient water access and produces moderate milk yields with high fat content.",
    "image_path": "assets/images/breeds/iranian_buffalo.png"
  },
  {
    "id": "breed_105",
    "name": "Kyrgyz Buffalo",
    "species": "Buffalo",
    "origin": "Kyrgyzstan",
    "avg_yield_per_lactation_liters": "800-1500",
    "avg_fat_percentage": 7.0,
    "description": "A hardy buffalo type raised in Central Asian farming systems, generally dark-coated with a robust frame. It adapts to warm summers and cooler seasonal conditions and produces modest milk quantities with rich fat content.",
    "image_path": "assets/images/breeds/kyrgyz_buffalo.png"
  },
  {
    "id": "breed_106",
    "name": "Bengal Buffalo",
    "species": "Buffalo",
    "origin": "Bangladesh and Eastern India",
    "avg_yield_per_lactation_liters": "400-1000",
    "avg_fat_percentage": 7.0,
    "description": "A smaller indigenous buffalo type with a dark coat and compact body, commonly found in rural and wetland areas. It is adapted to hot, humid conditions and provides modest milk production under low-input systems.",
    "image_path": "assets/images/breeds/bengal_buffalo.png"
  },
  {
    "id": "breed_107",
    "name": "Assam Hill Buffalo",
    "species": "Buffalo",
    "origin": "Assam, India",
    "avg_yield_per_lactation_liters": "400-900",
    "avg_fat_percentage": 7.0,
    "description": "A hardy, medium-sized buffalo type with a dark coat and strong body, adapted to hilly and humid environments. It produces modest milk quantities and is valued for its ability to thrive in traditional low-input systems.",
    "image_path": "assets/images/breeds/assam_hill_buffalo.png"
  },
  {
    "id": "breed_108",
    "name": "Manipur Buffalo",
    "species": "Buffalo",
    "origin": "Manipur, India",
    "avg_yield_per_lactation_liters": "400-900",
    "avg_fat_percentage": 7.0,
    "description": "A local buffalo type with a dark coat, sturdy body, and adaptation to humid hill environments. It produces modest milk yields and is maintained primarily for agricultural support and household dairy needs.",
    "image_path": "assets/images/breeds/manipur_buffalo.png"
  },
  {
    "id": "breed_109",
    "name": "Luit Buffalo",
    "species": "Buffalo",
    "origin": "Assam, India",
    "avg_yield_per_lactation_liters": "500-1000",
    "avg_fat_percentage": 7.0,
    "description": "A regional buffalo population associated with the Brahmaputra valley, generally dark-coated and sturdy. It is adapted to hot, humid conditions and produces modest milk with high fat content under traditional farming systems.",
    "image_path": "assets/images/breeds/luit_buffalo.png"
  },
  {
    "id": "breed_110",
    "name": "Gojri Buffalo",
    "species": "Buffalo",
    "origin": "Punjab and Jammu & Kashmir, India",
    "avg_yield_per_lactation_liters": "800-1500",
    "avg_fat_percentage": 7.0,
    "description": "A hardy buffalo type raised in the foothills and mountainous regions of northern India, with a dark coat and strong frame. It adapts to varied terrain and warm-to-temperate conditions and provides moderate milk production with high fat.",
    "image_path": "assets/images/breeds/gojri_buffalo.png"
  },
  {
    "id": "breed_111",
    "name": "Kundi Cross",
    "species": "Buffalo",
    "origin": "Sindh, Pakistan",
    "avg_yield_per_lactation_liters": "1500-2500",
    "avg_fat_percentage": 7.0,
    "description": "A dairy buffalo type incorporating Kundi genetics, generally black-coated with a sturdy body and curled horns. It is suited to the hot conditions of Sindh and produces rich milk under improved dairy management.",
    "image_path": "assets/images/breeds/kundi_cross.png"
  },
  {
    "id": "breed_112",
    "name": "Nili-Ravi Cross",
    "species": "Buffalo",
    "origin": "Pakistan and India",
    "avg_yield_per_lactation_liters": "1800-3000",
    "avg_fat_percentage": 7.2,
    "description": "A dairy buffalo type incorporating Nili-Ravi genetics, generally showing a black coat and strong dairy conformation. It is suited to warm South Asian climates with proper cooling and nutrition and produces high-fat milk.",
    "image_path": "assets/images/breeds/nili_ravi_cross.png"
  },
  {
    "id": "breed_113",
    "name": "Murrah Cross",
    "species": "Buffalo",
    "origin": "India",
    "avg_yield_per_lactation_liters": "1800-3000",
    "avg_fat_percentage": 7.2,
    "description": "A dairy buffalo cross incorporating Murrah genetics, typically black with a strong frame and developed udder. It adapts well to tropical and subtropical conditions and is selected for improved milk yield and fat content.",
    "image_path": "assets/images/breeds/murrah_cross.png"
  },
  {
    "id": "breed_114",
    "name": "Jersey Cross",
    "species": "Cow",
    "origin": "Global dairy regions",
    "avg_yield_per_lactation_liters": "3500-6500",
    "avg_fat_percentage": 4.5,
    "description": "A crossbred dairy cow combining Jersey genetics with another dairy breed, often showing a medium-sized frame and varied coat color. It can perform well in warm climates and is valued for balanced milk yield with relatively high butterfat.",
    "image_path": "assets/images/breeds/jersey_cross.png"
  },
  {
    "id": "breed_115",
    "name": "Holstein Sahiwal Cross",
    "species": "Cow",
    "origin": "Pakistan and India",
    "avg_yield_per_lactation_liters": "3500-6500",
    "avg_fat_percentage": 4.0,
    "description": "A crossbred dairy cow combining Holstein milk production with Sahiwal heat tolerance, commonly showing black-and-white, brown, or mixed coloring. It is suited to warm South Asian climates with good management and can offer improved yield over indigenous breeds.",
    "image_path": "assets/images/breeds/holstein_sahiwal_cross.png"
  },
  {
    "id": "breed_116",
    "name": "Brown Swiss Cross",
    "species": "Cow",
    "origin": "Global dairy regions",
    "avg_yield_per_lactation_liters": "5000-8000",
    "avg_fat_percentage": 4.0,
    "description": "A crossbred dairy cow combining Brown Swiss genetics with another breed, often producing a brown or mixed-colored coat and sturdy body. It performs well in varied climates and is valued for persistent lactation, milk protein, and durability.",
    "image_path": "assets/images/breeds/brown_swiss_cross.png"
  },
  {
    "id": "breed_117",
    "name": "Sahiwal Cross",
    "species": "Cow",
    "origin": "Pakistan and India",
    "avg_yield_per_lactation_liters": "1800-3500",
    "avg_fat_percentage": 4.5,
    "description": "A crossbred cow incorporating Sahiwal genetics, generally retaining good heat tolerance and a medium-to-large body. It is well suited to tropical and subtropical regions and may provide improved milk yield while maintaining environmental adaptability.",
    "image_path": "assets/images/breeds/sahiwal_cross.png"
  },
  {
    "id": "breed_118",
    "name": "Red Sindhi Cross",
    "species": "Cow",
    "origin": "Pakistan and India",
    "avg_yield_per_lactation_liters": "1500-3000",
    "avg_fat_percentage": 4.5,
    "description": "A crossbred cow incorporating Red Sindhi genetics, often showing reddish or mixed coat colors and strong tropical adaptation. It performs well in hot climates and can provide useful milk production with improved management.",
    "image_path": "assets/images/breeds/red_sindhi_cross.png"
  },
  {
    "id": "breed_119",
    "name": "Gir Cross",
    "species": "Cow",
    "origin": "India",
    "avg_yield_per_lactation_liters": "1800-3500",
    "avg_fat_percentage": 4.5,
    "description": "A crossbred dairy cow incorporating Gir genetics, often retaining a distinctive head profile and heat-tolerant characteristics. It is suited to warm climates and may offer improved milk production while maintaining resilience to tropical conditions.",
    "image_path": "assets/images/breeds/gir_cross.png"
  },
  {
    "id": "breed_120",
    "name": "Australian Milking Zebu",
    "species": "Cow",
    "origin": "Australia",
    "avg_yield_per_lactation_liters": "1800-3500",
    "avg_fat_percentage": 4.5,
    "description": "A heat-tolerant dairy cattle type developed using zebu genetics and selected for milk production. It generally has loose skin and a prominent hump and is suited to hot tropical and subtropical environments where resilience is important.",
    "image_path": "assets/images/breeds/australian_milking_zebu.png"
  }
  ];
}
