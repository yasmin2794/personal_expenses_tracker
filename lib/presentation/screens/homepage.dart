import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/models/transaction.dart';
import '../../helper/database_helper.dart';
import '../../services/notification_service.dart';
import '../widgets/chart.dart';
import '../widgets/new_transaction_form.dart';
import '../widgets/transaction_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> _userTransactions = [];
  bool _showChart = false;
  NotificationService notificationService = NotificationService();

  List<Transaction> get _recentTransactions{
    DateTime lastDayOfPrevWeek = DateTime.now().subtract(Duration(days: 6));
    lastDayOfPrevWeek = DateTime(
      lastDayOfPrevWeek.year, lastDayOfPrevWeek.month, lastDayOfPrevWeek.day);
    return _userTransactions.where((element){
      return element.txnDateTime.isAfter(lastDayOfPrevWeek);
    }
    ).toList();
  }

  _MyHomePageState(){
    _updateUserTransactionsList();
  }

  Future<void> _updateUserTransactionsList()async{
    Future<List<Transaction>> res =
        DatabaseHelper.instance.getAllTransactions();
    res.then((txnList){
        _userTransactions = txnList;
    });
    setState((){});
  }

void _showChartHandler(bool show){
    setState(() {
      _showChart = show;
    });
}
  Future<void> _updateTransaction(
      String title, double amount, DateTime chosenDate) async {
    final newTxn = Transaction(
      DateTime.now().millisecondsSinceEpoch.toString(),
      title,
      amount,
      chosenDate,
    );
    int res = await DatabaseHelper.instance.update(newTxn);
    if (res != 0) {
      _updateUserTransactionsList();
    }
  }

  Future<void> _addNewTransaction(
      String title, double amount, DateTime chosenDate) async {
    final newTxn = Transaction(
      DateTime.now().millisecondsSinceEpoch.toString(),
      title,
      amount,
      chosenDate,
    );
    int res = await DatabaseHelper.instance.insert(newTxn);
    if (res != 0) {
      _updateUserTransactionsList();
      setState(() {

      });
    }
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.60,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
            ),
          ),
          child: NewTransactionForm(_addNewTransaction),
        );
      },
    );
  }

  Future<void> _deleteTransaction(String id) async {
    int res =
    await DatabaseHelper.instance.deleteTransactionById(int.tryParse(id)!);
    if (res != 0) {
      _updateUserTransactionsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppBar myAppBar = AppBar(
      title: Text(
        'Personal Expenses',
        style: TextStyle(
          color: Colors.green[800],
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.notification_add),
          onPressed: () async {
            await notificationService.init();
    },
          tooltip: "Schedule notification")
      ],
    );
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final bool isLandscape =
        mediaQueryData.orientation == Orientation.landscape;

    final double availableHeight = mediaQueryData.size.height -
        myAppBar.preferredSize.height -
        mediaQueryData.padding.top -
        mediaQueryData.padding.bottom;

    final double availableWidth = mediaQueryData.size.width -
        mediaQueryData.padding.left -
        mediaQueryData.padding.right;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: myAppBar,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img.png'), fit: BoxFit.fill,
          )
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Switch.adaptive(
                      activeColor: Colors.purple,
                      value: _showChart,
                      onChanged: (value) => _showChartHandler(value),
                    ),
                  ],
                ),
              if (isLandscape)
                _showChart
                    ? myChartContainer(
                    height: availableHeight * 0.8,
                    width: 0.6 * availableWidth)
                    : myTransactionListContainer(
                    height: availableHeight * 0.8,
                    width: 0.6 * availableWidth),
              if (!isLandscape)
                myChartContainer(
                    height: availableHeight * 0.3, width: availableWidth),
              if (!isLandscape)
                myTransactionListContainer(
                    height: availableHeight * 0.7, width: availableWidth),

            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: "Add New Transaction",
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }

  Widget myChartContainer({required double height, required double width}) {
    return Column(
      children: [
        Text('Last one week expenses',
        style: TextStyle(fontSize: 18, color: Colors.purple[500], fontWeight: FontWeight.w500),),
        Container(
          height: height,
          width: width,
          child: Chart(_recentTransactions),
        ),
      ],
    );
  }

  Widget myTransactionListContainer({required double height, required double width}) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
      height: height,
      width: width,
      child: TransactionList(_userTransactions, _deleteTransaction, _updateTransaction),
    );
  }
}
