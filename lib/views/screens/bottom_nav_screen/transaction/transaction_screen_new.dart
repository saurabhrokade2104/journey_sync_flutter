import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionScreenNew extends StatefulWidget {
  const TransactionScreenNew({super.key});

  @override
  State<TransactionScreenNew> createState() => _TransactionScreenNewState();
}

class _TransactionScreenNewState extends State<TransactionScreenNew> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime? _selectedDate;
  String? _selectedTransactionType;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final List<String> _transactionTypes = ['All', 'Credit', 'Debit'];

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Filter Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      validator: (value) {
                        if (_selectedDate == null) {
                          return 'Please select a valid date';
                        }
                        // if (_selectedDate!.year > 2023) {
                        //   return 'Date should not be beyond 2023';
                        // }
                        return null;
                      },
                      onTap: () async {
                        DateTime initialDate =
                            DateTime.now().isBefore(DateTime(2023, 12, 31))
                                ? DateTime.now()
                                : DateTime(2023, 12, 31);

                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: initialDate,
                          firstDate: DateTime(2023),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                            _dateController.text =
                                '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
                          });
                        }
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.calendar_month),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        labelText: 'Date Range',
                        hintText: _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Select Date Range',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Transaction Type',
                      ),
                      value: _selectedTransactionType,
                      items: _transactionTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTransactionType = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a transaction type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          Navigator.pop(context);

                          Future.delayed(Duration(seconds: 4), () {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        }
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: false,
            title: Row(
              children: [
                // IconButton(
                //   padding: const EdgeInsets.all(0),
                //   icon: const Icon(
                //     Icons.menu,
                //     color: AppColors.whiteColor,
                //     size: 20,
                //   ),
                //   onPressed: () {
                //     Scaffold.of(context).openDrawer();
                //   },
                // ),
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: const Icon(
                    Icons.menu,
                    color: AppColors.whiteColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'FINOVEL',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'TitilliumWeb',
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/imgs/header_bg.png',
                  fit: BoxFit.fill,
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.whiteColor,
                  size: 20,
                ),
                onPressed: () {
                  Get.toNamed(RouteHelper.notificationScreen);
                },
              ),
            ],
            bottom: const TabBar(
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              tabs: [
                Tab(text: 'Transactions'),
                Tab(text: 'Statement'),
              ],
            ),
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.4)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: size.width * 0.8,
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    labelText: 'Search or filter transaction',
                                    suffixIcon: GestureDetector(
                                        onTap: () {

                                          if(_searchController.text.isEmpty){
                                            // CustomSnackBar.error(errorList: ['Please type something']);
                                            return;

                                          }
                                          setState(() {
                                            _isLoading = true;
                                          });

                                          Future.delayed(const Duration(seconds: 4),
                                              () {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          });
                                        },
                                        child: Icon(Icons.search)),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _showFilterBottomSheet(context),
                                icon: const Icon(Icons.filter_list),
                              ),
                            ],
                          ),
                          const TabBar(
                            labelColor: Colors.blue,
                            tabs: [
                              Tab(text: 'Finovel Pay'),
                              Tab(text: 'BBPS Bills'),
                              Tab(text: 'Other Bills'),
                            ],
                          ),
                          const Expanded(
                            child: TabBarView(
                              children: [
                                TransactionsTab(),
                                TransactionsTab(),
                                TransactionsTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/no_statement.png',
                            width: 350),
                        const SizedBox(height: 10),
                        const Text(
                          'No Statement Found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Looks like you haven’t made any transactions yet.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class TransactionsTab extends StatelessWidget {
  const TransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasTransactions = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: hasTransactions
          ? [
              // Your existing ListView.builder for transactions goes here
            ]
          : [
              Image.asset('assets/images/no_transaction.jpg', width: 150),
              const SizedBox(height: 20),
              const Text(
                'No Transactions Found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Looks like you haven’t made any transactions yet.',
                textAlign: TextAlign.center,
              ),
            ],
    );
  }
}
