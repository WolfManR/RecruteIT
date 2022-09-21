using Data;
using Data.Entities;
using Microsoft.AspNetCore.Mvc;
using WebProducts.Models;

namespace WebProducts.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProductsController : ControllerBase
    {
        private readonly ProductsRepository _productsRepository;

        public ProductsController(ProductsRepository productsRepository)
        {
            _productsRepository = productsRepository;
        }

        [HttpGet("find")]
        public IActionResult FindProducts([FromQuery]string productName)
        {
            var products = _productsRepository.FindProducts(productName);
            return Ok(products);
        }

        [HttpPost("add")]
        public IActionResult Add(CreateProductRequest request)
        {
            Product data = new()
            {
                Name = request.Name,
                Description = request.Description
            };
            var id = _productsRepository.Add(data);
            return Ok(id);
        }

        [HttpPut("update")]
        public IActionResult Update(UpdateProductRequest request)
        {
            Product data = new()
            {
                Id = request.Id,
                Name = request.Name,
                Description = request.Description
            };
            try
            {
                _productsRepository.Update(data);
                return Ok();
            }
            catch (KeyNotFoundException)
            {
                return NotFound();
            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }

        [HttpDelete("remove/{id}")]
        public IActionResult Remove(Guid id)
        {
            try
            {
                _productsRepository.Remove(id);
                return Ok();
            }
            catch (KeyNotFoundException)
            {
                return NotFound();
            }
            catch (Exception e)
            {
                return BadRequest();
            }
        }
    }
}