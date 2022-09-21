using Data.Contexts;
using Data.Entities;

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
        return Array.Empty<Product>();
    }

    public Guid Add(Product product)
    {
        return Guid.Empty;
    }

    public void Update(Product edited)
    {

    }

    public void Remove(Guid id)
    {

    }
}