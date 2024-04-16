import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _allTransactions;
  final Function _deleteTransaction;
  final Function _updateTransaction;

  TransactionList(this._allTransactions, this._deleteTransaction, this._updateTransaction);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return _allTransactions.isEmpty
      // No Transactions
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: constraints.maxHeight * 0.1,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Let's manage expenses!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      )
      // Transactions Present
          : ListView.builder(
        itemCount: _allTransactions.length,
        itemBuilder: (context, index) {
          Transaction txn = _allTransactions[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
            child: Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(
                vertical: 1.0,
                horizontal: 15.0,
              ),
              child: InkWell(
                onTap: () {},
                child: ListTile(
                  leading: Container(
                    width: 70.0,
                    height: 50.0,
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.green[500],
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        '₹${txn.txnAmount}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    txn.txnTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('MMMM d, y -')
                        .add_jm()
                        .format(txn.txnDateTime),
                    // DateFormat.yMMMMd().format(txn.txnDateTime),
                  ),
                  trailing: Wrap(
                    children:<Widget> [
                      /*IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.purple,
                        onPressed: () async {
                          await NewTransactionForm(_updateTransaction);
                          //_updateTransaction(txn.txnId);
                        },
                        tooltip: "Edit Transaction",
                      ),*/
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        color: Theme.of(context).colorScheme.error,
                        onPressed: () {
                          _deleteTransaction(txn.txnId);
                          /*showDialog(
                          context: context,
                          builder: (BuildContext context) {
                          return new AlertDialog(
                            title: Text('Do you really wanna delete?'),
                            actions: [
                              ElevatedButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: Text('NO')),
                              ElevatedButton(onPressed: () async {
                                await _deleteTransaction(txn.txnId);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: const Text(
                                    'Data deleted successfully',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  backgroundColor: Colors.purple[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  //behavior: SnackBarBehavior.floating,
                                ));
                                Navigator.pop(context);
                              }, child: Text('Yes'))
                            ],
                          );
                          });*/
                          },
                        tooltip: "Delete Transaction",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
