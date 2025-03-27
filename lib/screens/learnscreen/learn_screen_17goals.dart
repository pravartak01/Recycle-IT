import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final List<Map<String, dynamic>> goals = [
    {
      'number': '01',
      'title': 'No Poverty',
      'description': 'End poverty in all its forms everywhere',
      'icon': Iconsax.profile_2user,
      'color': Colors.red[700]!,
      'link': 'https://sdgs.un.org/goals/goal1',
      'facts': [
        '736 million people still live in extreme poverty',
        '10% of world population lives on less than \$1.90/day',
        'COVID-19 pushed 71 million into extreme poverty in 2020'
      ],
      'imageUrl': "https://sharon.operationeyesight.com/staging/wp-content/uploads/2022/08/NoPoverty.webp",
    },
    {
      'number': '02',
      'title': 'Zero Hunger',
      'description': 'End hunger, achieve food security and improved nutrition',
      'icon': Iconsax.cake,
      'color': Colors.orange[700]!,
      'link': 'https://sdgs.un.org/goals/goal2',
      'facts': [
        '690 million people are undernourished',
        '144 million children suffer from stunting',
        '3 billion people cannot afford a healthy diet'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-02.png',
    },
    {
      'number': '03',
      'title': 'Good Health',
      'description': 'Ensure healthy lives and promote well-being for all',
      'icon': Iconsax.health,
      'color': Colors.green[700]!,
      'link': 'https://sdgs.un.org/goals/goal3',
      'facts': [
        '400 million lack basic healthcare services',
        '5.2 million children died before age 5 in 2019',
        'HIV/AIDS remains a major global health issue'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-03.png',
    },
    {
      'number': '04',
      'title': 'Quality Education',
      'description': 'Ensure inclusive and equitable quality education',
      'icon': Iconsax.book,
      'color': Colors.red[800]!,
      'link': 'https://sdgs.un.org/goals/goal4',
      'facts': [
        '258 million children and youth were out of school in 2018',
        '617 million youth lack basic math and literacy skills',
        '4 million refugee children are out of school'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-04.png',
    },
    {
      'number': '05',
      'title': 'Gender Equality',
      'description': 'Achieve gender equality and empower all women and girls',
      'icon': Iconsax.woman,
      'color': Colors.pink[700]!,
      'link': 'https://sdgs.un.org/goals/goal5',
      'facts': [
        '1 in 3 women experience physical/sexual violence',
        'Only 25% of national parliamentarians are women',
        'Women do 2.6 times more unpaid care work than men'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-05.png',
    },
    {
      'number': '06',
      'title': 'Clean Water',
      'description': 'Ensure availability of water and sanitation for all',
      'icon': Iconsax.drop,
      'color': Colors.blue[700]!,
      'link': 'https://sdgs.un.org/goals/goal6',
      'facts': [
        '2.2 billion lack safely managed drinking water',
        '4.2 billion lack safely managed sanitation',
        '80% of wastewater flows back into ecosystems untreated'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-06.png',
    },
    {
      'number': '07',
      'title': 'Clean Energy',
      'description': 'Ensure access to affordable, reliable energy for all',
      'icon': Iconsax.flash,
      'color': Colors.yellow[700]!,
      'link': 'https://sdgs.un.org/goals/goal7',
      'facts': [
        '759 million people lack electricity access',
        '2.6 billion rely on polluting cooking fuels',
        'Renewables are now cheapest power option'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-07.png',
    },
    {
      'number': '08',
      'title': 'Decent Work',
      'description': 'Promote inclusive economic growth and decent work',
      'icon': Iconsax.briefcase,
      'color': Colors.deepPurple[700]!,
      'link': 'https://sdgs.un.org/goals/goal8',
      'facts': [
        '61% of workers are in informal employment',
        'COVID-19 cost equivalent of 255 million jobs',
        'Gender pay gap remains at 23% globally'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-08.png',
    },
    {
      'number': '09',
      'title': 'Industry & Innovation',
      'description': 'Build resilient infrastructure and foster innovation',
      'icon': Iconsax.cpu,
      'color': Colors.orange[800]!,
      'link': 'https://sdgs.un.org/goals/goal9',
      'facts': [
        '2.6 billion lack access to electricity',
        '4 billion people lack internet access',
        'R&D investment remains below target'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-09.png',
    },
    {
      'number': '10',
      'title': 'Reduced Inequalities',
      'description': 'Reduce inequality within and among countries',
      'icon': Iconsax.chart_2,
      'color': Colors.pink[800]!,
      'link': 'https://sdgs.un.org/goals/goal10',
      'facts': [
        'Poorest 40% earn less than 25% of global income',
        'COVID-19 increased inequality worldwide',
        'Migrants face disproportionate challenges'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-10.png',
    },
    {
      'number': '11',
      'title': 'Sustainable Cities',
      'description': 'Make cities inclusive, safe, resilient and sustainable',
      'icon': Iconsax.buildings,
      'color': Colors.yellow[800]!,
      'link': 'https://sdgs.un.org/goals/goal11',
      'facts': [
        '4.2 billion urban residents in 2018',
        '90% of urban growth occurs in developing world',
        'Cities produce 70% of global CO2 emissions'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-11.png',
    },
    {
      'number': '12',
      'title': 'Responsible Consumption',
      'description': 'Ensure sustainable consumption and production',
      'icon': Iconsax.shopping_cart,
      'color': Colors.brown[700]!,
      'link': 'https://sdgs.un.org/goals/goal12',
      'facts': [
        '1.3 billion tons of food wasted annually',
        'If everyone lived like EU residents, we\'d need 2.8 Earths',
        'Electronic waste growing at alarming rates'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-12.png',
    },
    {
      'number': '13',
      'title': 'Climate Action',
      'description': 'Take urgent action to combat climate change',
      'icon': Iconsax.cloud,
      'color': Colors.teal[700]!,
      'link': 'https://sdgs.un.org/goals/goal13',
      'facts': [
        'Last decade was warmest on record',
        'Global emissions must fall 7.6% annually',
        'Climate finance remains insufficient'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-13.png',
    },
    {
      'number': '14',
      'title': 'Life Below Water',
      'description': 'Conserve and sustainably use ocean resources',
      'icon': Iconsax.box,
      'color': Colors.blue[800]!,
      'link': 'https://sdgs.un.org/goals/goal14',
      'facts': [
        'Ocean absorbs 30% of CO2 emissions',
        'Over 3 billion depend on marine biodiversity',
        'Plastic pollution increased tenfold since 1980'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-14.png',
    },
    {
      'number': '15',
      'title': 'Life On Land',
      'description': 'Protect and promote sustainable land ecosystems',
      'icon': Iconsax.tree,
      'color': Colors.green[800]!,
      'link': 'https://sdgs.un.org/goals/goal15',
      'facts': [
        '1 million species at risk of extinction',
        '75% of land surface significantly altered',
        'Deforestation continues at alarming rate'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-15.png',
    },
    {
      'number': '16',
      'title': 'Peace & Justice',
      'description': 'Promote peaceful and inclusive societies',
      'icon': Iconsax.security,
      'color': Colors.blue[900]!,
      'link': 'https://sdgs.un.org/goals/goal16',
      'facts': [
        '100 million displaced people globally',
        'Corruption costs \$1.26 trillion annually',
        '1 in 4 children lack birth registration'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-16.png',
    },
    {
      'number': '17',
      'title': 'Partnerships',
      'description': 'Strengthen implementation and global partnerships',
      'icon': Iconsax.global,
      'color': Colors.indigo[700]!,
      'link': 'https://sdgs.un.org/goals/goal17',
      'facts': [
        'Official development assistance at \$161 billion',
        'Developing countries face \$2.5 trillion funding gap',
        'Debt burdens increasing for poorest countries'
      ],
      'imageUrl': 'https://www.un.org/sustainabledevelopment/wp-content/uploads/2019/07/E_SDG-goals_icons-individual-rgb-17.png',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://unosd.un.org/sites/unosd.un.org/files/img_sdgs01_kr_0.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The 17 Global Goals',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900]!,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The Sustainable Development Goals (SDGs) are the world\'s shared plan to end extreme poverty, reduce inequality, and protect the planet by 2030.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700]!,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final goal = goals[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildGoalCard(goal, index),
                );
              },
              childCount: goals.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse('https://sdgs.un.org/goals');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700]!,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Explore All Goals on UN Website'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal, int index) {
    final color = goal['color'] as Color;
    final title = goal['title'] as String;
    final description = goal['description'] as String? ?? 'No description available';
    final number = goal['number'] as String;
    final icon = goal['icon'] as IconData;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showGoalDetails(context, goal);
        },
        child: Container(
          height: 150,
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          number,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Icon(icon, size: 30, color: color),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey[800]!,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600]!,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: (100 * index).ms).fadeIn().slideX(begin: 0.2);
  }

  void _showGoalDetails(BuildContext context, Map<String, dynamic> goal) {
    final color = goal['color'] as Color;
    final title = goal['title'] as String;
    final description = goal['description'] as String? ?? 'No description available';
    final number = goal['number'] as String;
    final facts = (goal['facts'] as List<dynamic>).cast<String>();
    final link = goal['link'] as String;
    final imageUrl = goal['imageUrl'] as String;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
        children: [
        Padding(
        padding: EdgeInsets.all(16),
        child: Row(
        children: [
        IconButton(
        icon: Icon(Iconsax.arrow_left),
        onPressed: () => Navigator.pop(context),
        ),
        Text(
        'SDG $number',
        style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        ),
        ),
        Spacer(),
        IconButton(
        icon: Icon(Iconsax.share, color: Colors.grey[600]!),
        onPressed: () async {
        final url = Uri.parse(link);
        if (await canLaunchUrl(url)) {
        await launchUrl(url);
        }
        },
        ),
        ],
        ),
        ),
        Expanded(
        child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Container(
        height: 200,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withOpacity(0.1),
        ),
        child: Center(
        child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
        Icons.error_outline,
        size: 50,
        color: Colors.grey,
        ),
        loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
        child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
        ? loadingProgress.cumulativeBytesLoaded /
        loadingProgress.expectedTotalBytes!
            : null,
        ),
        );
        },
        ),
        ),
        ),
        SizedBox(height: 20),
        Text(
        title,
        style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color,
        ),
        ),
        SizedBox(height: 8),
        Text(
        description,
        style: TextStyle(
        fontSize: 18,
        color: Colors.grey[700]!,
        ),
        ),
        SizedBox(height: 24),
        Text(
        'Key Facts:',
        style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        ),
        ),
        SizedBox(height: 12),
        Column(
        children: facts.map((fact) {
        return Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Icon(
        Iconsax.info_circle,
        size: 20,
        color: color,
        ),
        SizedBox(width: 8),
        Expanded(
        child: Text(
        fact,
        style: TextStyle(
        fontSize: 16,
        height: 1.4,
        ),
        ),
        ),
        ],
        ),
        );
        }).toList(),
        ),
        SizedBox(height: 24),
        ElevatedButton(
        onPressed: () async {
        final url = Uri.parse(link);
        if (await canLaunchUrl(url)) {
        await launchUrl(url);
        }
        },
        style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(double.infinity, 50),
        ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Icon(Iconsax.global),
        SizedBox(width: 8),
        Text('Learn More on UN Website'),
        ],
        ),
        ),
        SizedBox(height: 40),
        ],
        ),
        ),
        ),
        ],
        ),
        );
      },
    );
  }
}