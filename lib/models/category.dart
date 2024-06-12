class Category {
  final int id;
  final String title;
  final List<Category>
      children; // Since this is an expansion list ...children can be another list of entries
  Category(this.id, this.title, [this.children = const <Category>[]]);
}

final List<Category> data = <Category>[
  Category(
    1,
    'Business',
    <Category>[
      Category(11, 'Accounting'),
      Category(12, 'Accounting in Arabic'),
      Category(13, 'Marketing'),
      Category(14, 'System'),
    ],
  ),
  // Second Row
  Category(2, 'Computer', <Category>[
    Category(21, 'Information Technology and Computing'),
    Category(22, 'Computer Science'),
    Category(23, 'Computing with Business'),
    Category(24, 'Network and Security'),
    Category(25, 'Web Development'),
  ]),
  Category(
    3,
    'Language',
    <Category>[
      Category(31, 'Language and Literature'),
    ],
  ),
];
