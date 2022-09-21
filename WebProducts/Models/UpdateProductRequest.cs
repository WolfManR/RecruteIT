namespace WebProducts.Models;

public class UpdateProductRequest
{
    public Guid Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
}