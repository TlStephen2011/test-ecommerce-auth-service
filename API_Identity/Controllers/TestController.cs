using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;

namespace API_Identity.Controllers;

[Route("api/[controller]")]
[ApiController]
public class TestController : Controller
{
   [HttpGet]
   public IActionResult Test()
   {
      return Ok("This is a test");
   }
}