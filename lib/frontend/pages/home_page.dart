import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:gym_sync/core/state/getx_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CustomerController customerController = Get.put(CustomerController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGymHeaderCard(),
            const SizedBox(height: 10),

            _buildMonthlyIncomeCard(context),

            const SizedBox(height: 10),

            _buildMemberStatisticsGrid(context),
          ],
        );
      }),
    );
  }

  Widget _buildGymHeaderCard() {
    const primaryColor = Color(0xff3F4E4F);
    const highlightColor = Color(0xffDCD7C9);
    const lightTextColor = Color(0xffEEEBE3);
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: primaryColor,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gym Name Section
            Row(
              children: [
                Icon(Icons.fitness_center, color: highlightColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    customerController.gymName,
                    style: TextStyle(
                      color: lightTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Owner Name Section
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: highlightColor.withOpacity(0.8),
                  size: 18,
                ),
                const SizedBox(width: 12),
                Text(
                  "Owner: ${customerController.ownerName}",
                  style: TextStyle(
                    color: highlightColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Date section
            Text(
              "Today: ${DateFormat('EEEE, MMM d, yyyy').format(DateTime.now())}",
              style: TextStyle(
                color: highlightColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyIncomeCard(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd MMM, yyyy');
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              'Monthly Income',
              style: TextStyle(
                color: Theme.of(context).highlightColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  '₹${customerController.monthlyIncome.value}',
                  style: TextStyle(
                    color: Theme.of(context).highlightColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Icon(
                  Icons.trending_up_rounded,
                  color: Colors.green[300],
                  size: 40,
                ),
              ],
            ),
            const SizedBox(height: 10),
            AutoSizeText(
              'Last updated: ${dateFormat.format(DateTime.now())}',
              style: TextStyle(
                color: Theme.of(context).highlightColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberStatisticsGrid(BuildContext context) {
    int totalMembers = customerController.totalMembers.value;
    int activeMembers = customerController.activeMembers.value;
    int inactiveMembers = customerController.inactiveMembers.value;
    int expiredMembers = totalMembers - activeMembers - inactiveMembers;

    final List<Map<String, dynamic>> stats = [
      {
        'icon': Icons.groups_rounded,
        'title': 'Total Members',
        'value': "$totalMembers",
        'color': Colors.blue[300]!,
      },
      {
        'icon': Icons.check_circle_outline_rounded,
        'title': "Active Members",
        'value': "$activeMembers",
        'color': Colors.green[300]!,
      },
      {
        'icon': Icons.warning_amber_rounded,
        'title': "Expired Members",
        'value': "$expiredMembers",
        'color': Colors.orange[300]!,
      },
      {
        'icon': Icons.cancel_outlined,
        'title': "Inactive Members",
        'value': "$inactiveMembers",
        'color': Colors.red[300]!,
      },
    ];
    List<Widget> statsWidgets =
        stats
            .map(
              (map) => _buildStatisticBox(
                context,
                icon: map['icon'],
                title: map['title'],
                value: map['value'],
                color: map['color'],
              ),
            )
            .toList();
    return Padding(
      padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 20,
          childAspectRatio: 1,
          mainAxisExtent: 140,
        ),
        shrinkWrap: true,
        children: statsWidgets,
      ),
    );
  }

  // Individual Statistic Box
  Widget _buildStatisticBox(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  value,
                  style: TextStyle(
                    color: Theme.of(context).highlightColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 5),
                AutoSizeText(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).highlightColor,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
