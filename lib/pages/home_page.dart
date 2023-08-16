import 'package:contact_crud_app/model/contact.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

String filterOption = 'All';
class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String? contactType;
  List<Contact> contacts = List.empty(growable: true);
  String searchText = '';

  // To Filter Contacts through Filter icon
  List<Contact> get filteredContactsIcon {
    return contacts.where((contact) {
      final name = contact.category;
      if (filterOption == 'All') {
          return name.contains('');
      } else{
        return name.contains(filterOption);
      }
    }).toList();
  }

  // To Filter Contacts through Search Bar
  List<Contact> get searchedContacts {
    return filteredContactsIcon.where((contact) {
      final name = contact.name.toLowerCase();
      final search = searchText.toLowerCase();
      return name.contains(search);
    }).toList();
  }

  void reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Contacts', style: TextStyle(color: Colors.black),),
        backgroundColor: Color(0xffF6F6F6),
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context) => ShowFilter(),);},
              icon: Icon(Icons.filter_list, color: Colors.black, size: 28,))
        ],
      ),
      floatingActionButton: CircleAvatar(
        backgroundColor: Colors.indigo,
        child: IconButton(
          icon: Icon(Icons.add, size: 25, color: Colors.white,),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    StatefulBuilder(builder: (context, setState) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          width: 300.0,
                          height: 430,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Create New', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 15,),
                                Text(
                                  'Name', style: TextStyle(color: Colors.red),),
                                TextFormField(autofocus: true, controller: nameController, keyboardType: TextInputType.name,),
                                SizedBox(height: 10,),
                                Text('Mobile no', style: TextStyle(color: Colors.red),),
                                TextFormField(
                                  controller: numberController,
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: 30,),
                                Text('Contact Type', style: TextStyle(color: Colors.red),),
                                RadioListTile(
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
                                  title: Text("Business"),
                                  value: "Business",
                                  groupValue: contactType,
                                  onChanged: (value) {
                                    setState(() {
                                      contactType = value.toString();
                                    });
                                  },
                                ),
                                RadioListTile(
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
                                  title: Text("Personal"),
                                  value: "Personal",
                                  groupValue: contactType,
                                  onChanged: (value) {
                                    setState(() {
                                      contactType = value.toString();
                                    });
                                  },
                                ),
                                SizedBox(height: 10,),
                                Divider(height: 10, thickness: 2,),
                                Center(
                                    child: TextButton(
                                        onPressed: () {
                                          String name = nameController.text;
                                          String number = numberController.text;
                                          if (name.isNotEmpty &&
                                              number.isNotEmpty) {
                                            reload();
                                            contacts.add(Contact(
                                                name: name,
                                                number: number,
                                                category: contactType!));
                                            contactType = '';
                                            nameController.text = '';
                                            numberController.text = '';
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text(
                                          'Add', style: TextStyle(color: Colors.indigo, fontSize: 20, fontWeight: FontWeight.bold),)))
                              ],
                            ),
                          ),
                        ),
                      );
                    }));
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20,10,20,10),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200], // Set your desired background color here
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextField(
                autofocus: false,
                controller: searchController,
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(

                    prefixIcon: const Icon(Icons.search_outlined, color: Colors.black,),
                    fillColor: Colors.black12,
                    focusColor: Colors.black12,
                    suffixIcon: searchText.isNotEmpty? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          searchController.text = '';
                          searchText = '';
                        });
                      },
                    ): null,
                    hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: searchedContacts.length,
                itemBuilder: (context, index) {
                  final contactWithIndex = searchedContacts[index];
                  return getContactItem( index, contactWithIndex);
                }
                ),
          ),
        ],
      ),
    );
  }


  Widget getContactItem(int index, final contactWithIndex) {
    return  Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            child: Text(
              contactWithIndex.name[0].toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contactWithIndex.name, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
              Row(
                children: [
                  Text(contactWithIndex.category, style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.normal), ),
                  SizedBox(width: 10,),
                  Text(contactWithIndex.number, style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.normal),),
                ],
              ),
            ],
          ),
          onTap: () {
            nameController.text = searchedContacts[index].name;
            numberController.text = searchedContacts[index].number;
            contactType = searchedContacts[index].category;

            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    StatefulBuilder(builder: (context, setState) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12.0)),
                        //this right here
                        child: Container(
                          width: 300.0,
                          height: 440,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Edit', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                                SizedBox(height: 15,),
                                Text('Name', style: TextStyle(color: Colors.red),),
                                TextFormField(
                                  controller: nameController,
                                  keyboardType: TextInputType.name,
                                ),
                                SizedBox(height: 10,),
                                Text('Mobile no', style: TextStyle(color: Colors.red),),
                                TextFormField(
                                  controller: numberController,
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: 30,),
                                Text('Contact Type', style: TextStyle(color: Colors.red),),
                                RadioListTile(
                                  title: Text("Business"),
                                  value: "Business",
                                  groupValue: contactType,
                                  onChanged: (value) {
                                    setState(() {
                                      contactType = value.toString();
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: Text("Personal"),
                                  value: "Personal",
                                  groupValue: contactType,
                                  onChanged: (value) {
                                    setState(() {
                                      contactType = value.toString();
                                    });
                                  },
                                ),
                                SizedBox(height: 10,),
                                Divider(height: 10, thickness: 2,),
                                Center(
                                    child: IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                contacts.removeAt(index);
                                                nameController.text = '';
                                                numberController.text = '';
                                                contactType = '';
                                                reload();
                                                Navigator.pop(context);
                                              },
                                              child: Text('Delete', style: TextStyle(color: Colors.indigo, fontSize: 20, fontWeight: FontWeight.bold))),

                                          VerticalDivider(
                                            color: Colors.black26,
                                            thickness: 1,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                String name = nameController.text;
                                                String number = numberController.text;
                                                Navigator.pop(context);

                                                if (name.isNotEmpty && number.isNotEmpty) {
                                                  reload();
                                                  searchedContacts[index].name = name;
                                                  searchedContacts[index].number = number;
                                                  searchedContacts[index].category = contactType!;
                                                  contactType = '';
                                                  nameController.text = '';
                                                  numberController.text = '';
                                                }

                                              },
                                              child: Text('Update',style: TextStyle(color: Colors.indigo, fontSize: 20, fontWeight: FontWeight.bold))),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    }));
          },
        ),
        Divider(height: 4, thickness: 2, indent: 70, endIndent: 25,),
      ],
    );

  }

  void searchContact(String value) {}

  Widget ShowFilter() {
    return StatefulBuilder(builder: (context, setState) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), //this right here
        child: Container(
          width: 300.0,
          height: 270,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Icon(
                      Icons.filter_list,
                      color: Colors.black,
                    ),
                    SizedBox(width: 15,),
                    Text(
                      'Filter',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
                  title: Text("All"),
                  value: "All",
                  groupValue: filterOption,
                  onChanged: (value) {
                    setState(() {
                      filterOption = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
                  contentPadding: EdgeInsets.zero,
                  title: Text("Business"),
                  value: "Business",
                  groupValue: filterOption,
                  onChanged: (value) {
                    setState(() {
                      filterOption = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
                  title: Text("Personal"),
                  value: "Personal",
                  groupValue: filterOption,
                  onChanged: (value) {
                    setState(() {
                      filterOption = value.toString();
                    });
                  },
                ),
                SizedBox(height: 10,),
                Divider(height: 10, thickness: 2,),
                Center(
                    child: TextButton(
                        onPressed: () {
                          reload();
                          Navigator.pop(context);
                        },
                        child: Text('OK', style: TextStyle(color: Colors.indigo, fontSize: 20, fontWeight: FontWeight.bold))))
              ],
            ),
          ),
        ),
      );
    });
  }

}


