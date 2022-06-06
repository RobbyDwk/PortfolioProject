Select *
from PortfolioProject..[Covid Deaths]
Where continent is not null
order by 3,4

Select *
from PortfolioProject..[Covid Vaccination]
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..[Covid Deaths]
order by 1,2


Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..[Covid Deaths]
Where location like '%Indonesia%'
order by 1,2


Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..[Covid Deaths]
Where location like '%Indonesia%'
order by 1,2


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..[Covid Deaths]
--Where location like '%Indonesia%' --Can be added in if want to look at Indonesia
Group by Location, Population
order by PercentPopulationInfected desc


Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..[Covid Deaths]
Where continent is not null
Group by location
order by TotalDeathCount desc

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..[Covid Deaths]
Where continent is not null
Group by continent
order by TotalDeathCount desc


 


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float, vac.new_vaccinations)) OVER (partition by dea.location) AS RollingPeopleVaccinated
From PortfolioProject..[Covid Deaths] dea
Join PortfolioProject..[Covid Vaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, CONVERT(float, vac.new_vaccinations))) OVER (partition by dea.location) AS RollingPeopleVaccinated
From PortfolioProject..[Covid Deaths] dea
Join PortfolioProject..[Covid Vaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, CONVERT(float, vac.new_vaccinations))) OVER (partition by dea.location) AS RollingPeopleVaccinated
From PortfolioProject..[Covid Deaths] dea
Join PortfolioProject..[Covid Vaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3



With PopvsVac(Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, CONVERT(float, vac.new_vaccinations))) OVER (partition by dea.location) AS RollingPeopleVaccinated
From PortfolioProject..[Covid Deaths] dea
Join PortfolioProject..[Covid Vaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac
Where location Like '%indonesia%'






DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations float,
RollingPeopleVaccinated numeric,
)

Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, CONVERT(float, vac.new_vaccinations))) OVER (partition by dea.location) AS RollingPeopleVaccinated
From PortfolioProject..[Covid Deaths] dea
Join PortfolioProject..[Covid Vaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated





Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, CONVERT(float, vac.new_vaccinations))) OVER (partition by dea.location) AS RollingPeopleVaccinated
From PortfolioProject..[Covid Deaths] dea
Join PortfolioProject..[Covid Vaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


select *
from PercentPopulationVaccinated