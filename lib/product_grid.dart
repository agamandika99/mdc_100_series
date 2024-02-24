import 'package:flutter/material.dart';
import 'model/product.dart';
import 'model/products_repository.dart';

class ProductGrid extends StatefulWidget {
  final Category category;

  const ProductGrid({required this.category, Key? key}) : super(key: key);

  @override
  _ProductGridState createState() => _ProductGridState();
}

enum FilterOption { priceLowToHigh, priceHighToLow, accessories, clothing, home, all }

class _ProductGridState extends State<ProductGrid> {
  late List<Product> _products;
  late List<Product> _filteredProducts;
  FilterOption _selectedFilter = FilterOption.all;
  String _searchKeyword = '';

  List<Product> _originalProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _products = ProductsRepository.loadProducts(widget.category);
      _originalProducts = List.from(_products);
      _applyFilter(_selectedFilter);
    });
  }

  void _applyFilter(FilterOption filterOption) {
    setState(() {
      _selectedFilter = filterOption;
      switch (filterOption) {
        case FilterOption.priceLowToHigh:
          _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case FilterOption.priceHighToLow:
          _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case FilterOption.accessories:
          _filteredProducts = _originalProducts.where((product) => product.category == Category.accessories).toList();
          break;
        case FilterOption.clothing:
          _filteredProducts = _originalProducts.where((product) => product.category == Category.clothing).toList();
          break;
        case FilterOption.home:
          _filteredProducts = _originalProducts.where((product) => product.category == Category.home).toList();
          break;
        case FilterOption.all:
          _filteredProducts = List.from(_originalProducts);
          break;
      }
      _filterProducts(_searchKeyword);
    });
  }


  void _filterProducts(String keyword) {
    setState(() {
      _searchKeyword = keyword.toLowerCase(); // Ubah keyword menjadi lowercase
      _filteredProducts = _originalProducts.where((product) {
        // Periksa apakah keyword cocok dengan nama produk atau harga produk
        final nameMatch = product.name.toLowerCase().contains(_searchKeyword);
        final priceMatch = product.price.toString().toLowerCase().contains(_searchKeyword);
        return nameMatch || priceMatch; // Kembalikan true jika ada kecocokan dengan nama atau harga produk
      }).toList();

      // Terapkan filter berdasarkan kategori produk yang dipilih
      switch (_selectedFilter) {
        case FilterOption.priceLowToHigh:
          _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case FilterOption.priceHighToLow:
          _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case FilterOption.accessories:
          _filteredProducts = _filteredProducts.where((product) => product.category == Category.accessories).toList();
          break;
        case FilterOption.clothing:
          _filteredProducts = _filteredProducts.where((product) => product.category == Category.clothing).toList();
          break;
        case FilterOption.home:
          _filteredProducts = _filteredProducts.where((product) => product.category == Category.home).toList();
          break;
        case FilterOption.all:
        // Tidak perlu dilakukan filter tambahan jika "Show All" dipilih
          break;
      }

      // Terapkan sorting jika filter yang dipilih adalah harga terendah ke tertinggi atau sebaliknya
      if (_selectedFilter == FilterOption.priceLowToHigh) {
        _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
      } else if (_selectedFilter == FilterOption.priceHighToLow) {
        _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(0, 0, 0, 0),
                    items: [
                      PopupMenuItem(
                        child: Text('Price: Low to High'),
                        value: FilterOption.priceLowToHigh,
                      ),
                      PopupMenuItem(
                        child: Text('Price: High to Low'),
                        value: FilterOption.priceHighToLow,
                      ),
                      PopupMenuItem(
                        child: Text('Category: Accessories'),
                        value: FilterOption.accessories,
                      ),
                      PopupMenuItem(
                        child: Text('Category: Clothing'),
                        value: FilterOption.clothing,
                      ),
                      PopupMenuItem(
                        child: Text('Category: Home'),
                        value: FilterOption.home,
                      ),
                      PopupMenuItem(
                        child: Text('Show All'),
                        value: FilterOption.all,
                      ),
                    ],
                  ).then((selectedValue) {
                    if (selectedValue != null) {
                      _applyFilter(selectedValue as FilterOption);
                    }
                  });
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    onChanged: _filterProducts,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredProducts.isEmpty
              ? Center(
            child: Text(
              'Barang yang dicari tidak ada',
              style: TextStyle(fontSize: 18.0),
            ),
          )
              : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 1.0,
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (BuildContext context, int index) {
              return GridTile(
                child: ProductCard(product: _filteredProducts[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Image.asset(
              product.assetName,
              package: product.assetPackage,
              fit: BoxFit.cover, // Mengatur gambar sesuai dengan kotak
            ),
          ),
          Text(product.name),
          Text('\$${product.price}'),
        ],
      ),
    );
  }
}

