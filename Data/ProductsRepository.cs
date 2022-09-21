using Data.Contexts;
using Data.Entities;
using Microsoft.EntityFrameworkCore;

namespace Data;

public class ProductsRepository
{
    private readonly TestDbContext _context;

    public ProductsRepository(TestDbContext context)
    {
        _context = context;
    }

    public IReadOnlyCollection<Product> FindProducts(string productName)
    {
        var products = _context.Products.AsNoTracking().Where(p => p.Name.Contains(productName)).ToList();
        return products;
    }

    public Guid Add(Product product)
    {
        _context.Products.Add(product);
        _context.SaveChanges();
        return product.Id;
    }

    public void Update(Product edited)
    {
        var product = _context.Products.Find(edited.Id);
        if (product is null) throw new KeyNotFoundException($"Can't update not existed product with id: {edited.Id}");

        product.Name = edited.Name;
        product.Description = edited.Description;

        _context.SaveChanges();
    }

    public void Remove(Guid id)
    {
        var product = _context.Products.Find(id);
        if(product is null) throw new KeyNotFoundException($"Can't delete not existed product with id: {id}");
        _context.Products.Remove(product);
        _context.SaveChanges();
    }
}