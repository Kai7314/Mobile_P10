using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MyAPI_demo.Models;

namespace MyAPI_demo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HomeController : ControllerBase
    {
       private static List<Student> StudentData = new List<Student>()
        {
           new Student(){Id="250001", Name="Alex", Gender="M", programme= "RSD", YearofStudy=1 },
           new Student(){Id="250002", Name="John", Gender="M", programme=  "RSD", YearofStudy=1 },
           new Student(){Id="250003", Name="Mark", Gender="M", programme= "RIT", YearofStudy=2 },
           new Student(){Id="250004", Name="Steven", Gender="M", programme= "RSW", YearofStudy=1 },
           new Student(){Id="250005", Name="Stella", Gender="F", programme= "RSW", YearofStudy=3 },
           new Student(){Id="250006", Name="Amine",  Gender="F", programme=  "RSD", YearofStudy=1 },
           new Student(){Id="250007", Name="Rahmat",  Gender="M", programme= "RIT", YearofStudy=2 },
           new Student(){Id="250008", Name="Aiman", Gender="M", programme= "RIT", YearofStudy=1 },
           new Student(){Id="250009", Name="Johnny", Gender="M", programme=  "RDS", YearofStudy=2 },

        };

        [HttpGet("GetAll")]
        public IActionResult Get()
        {
            if (StudentData == null || StudentData.Count == 0)
            {
                return NotFound("No record found");
            }
            else
            {
                return Ok(StudentData.ToList());
            }
        }

        [HttpGet("GetById/{id}")]
        public IActionResult GetById(string id)
        {

            var student = StudentData.FirstOrDefault(s => s.Id == id);

            if (student == null)
            {
                return NotFound($"No record found for id {id}");
            }
            else
            {
                return Ok(student);
            }

        }

        [HttpGet("GetByProgrammeCode/{programme}")]
        public IActionResult GetByProgramme(string programme)
        {

            var student = StudentData.Where(s => s.programme == programme).ToList();

            if (student.Count == 0)
            {
                return NotFound($"No record found for programme code {programme}");
            }
            else
            {
                return Ok(student);
            }

        }


        [HttpPost ("add")]
        public IActionResult add([FromBody] Student student)
        {

            try
            {
               StudentData.Add(student);

               return Ok(new { message= $"Student with ID {student.Id} added successful" } );
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
           
        }


        [HttpPut("update")]
        public IActionResult update([FromBody] Student student)
        {

            try
            {

                Student temp = StudentData.FirstOrDefault(s => s.Id == student.Id)!;
                temp.programme = student.programme;

                return Ok(new { message = $"Student with ID {student.Id} update successful" });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }

    }
}
