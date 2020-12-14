import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/material.dart';

import './components/transaction_form.dart';
import './components/transaction_list.dart';
import 'models/transaction.dart';
import 'dart:math';
import 'components/chart.dart';

//sempre iniciar com o metodo main estanciando a classe inicial do app
main() => runApp(ExpensesApp());

//class principal
class ExpensesApp extends StatelessWidget {
  @override
  //recebendo um metodo build onde ele retorna alguma parte do app ou todo ele
  Widget build(
    BuildContext context,
  ) {
    //nesse caso retornando um materialapp recebendo o home com a class da home
    //page
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //lista de constantes
  final List<Transaction> _transactions = [];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });
    //apos submeter o modal ele feixa pop e para tiar o primeiro elemento
    // da pilha
    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) {
        return tr.id == id;
      });
    });
  }

  _opentransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    //sempre retornando um Scaffold
    return Scaffold(
      //criando uma app bar ou barra de controle
      appBar: AppBar(
        //app bar recebendo um elemento do tipo testo
        title: Text(
          'Despesas Pessoais',
        ),
        //adicionando o botao na app bar
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _opentransactionFormModal(context),
          ),
        ],
      ),
      //dividindo o corpo ou body em colunas
      //SingleChieldScrollview para fazer a aplicaçao ter scroll
      body: SingleChildScrollView(
        child: Column(
          //elementos filhos
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //container que seria um divisor de conteudo recebendo dimençoes
            //Container(
            //largura do container
            // width: double.infinity,
            //outro componente filho recebendo um elemento card
            // child: Card(
            //onde recebe customisaçoes
            //  color: Colors.blue,
            // child: Text('Gráfico'),
            // elevation: 5,
            // ),
            //),
            Chart(_recentTransactions),
            TransactionsList(_transactions, _removeTransaction),
          ],
        ),
      ),
      //adicionando o botao no roda pe da pagia
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _opentransactionFormModal(context),
      ),
      //posicionando o botao nao centro
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
