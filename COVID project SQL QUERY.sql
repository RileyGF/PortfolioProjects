
--CTE

With PopvsVac (continent, Location, date, population, new_cases, new_deaths, new_vaccinations, total_vaccinations, RollingPeopleVaccinated, PercentPopulatoinInfected, PercentPopulatoinVaccinated, DeathRate)
as
(

Select dea.continent, dea.Location, dea.date, dea.population, dea.new_cases,dea.new_deaths,vac.new_vaccinations,vac.total_vaccinations, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated,
MAX((dea.total_cases/dea.population))*100 as PercentPopulatoinInfected, MAX((vac.total_vaccinations/dea.population))*100 as PercentPopulatoinVaccinated, (dea.total_deaths/dea.total_cases)*100 as DeathRate
From [Portfolio Poject]..CovidDeaths dea
Join [Portfolio Poject]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
group by dea.continent, dea.Location, dea.date, dea.population, dea.new_cases,dea.new_deaths, vac.new_vaccinations,vac.total_vaccinations, dea.total_deaths, dea.total_cases
)
Select *, (RollingPeopleVaccinated/population)*100 as RollingPercentOfPeopleVaccinated
From PopvsVac



--TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
date datetime,
population Numeric,
new_vaccinations Numeric,
RollingPeopleVaccinated Numeric,
)

-- Query going into temp table (#PercentPopulationVaccinated)

INSERT into #PercentPopulationVaccinated
Select dea.continent, dea.Location, dea.date, dea.population,vac.new_vaccinations, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
From [Portfolio Poject]..CovidDeaths dea
Join [Portfolio Poject]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
group by dea.continent, dea.Location, dea.date, dea.population, dea.new_cases,dea.new_deaths, vac.new_vaccinations,vac.total_vaccinations, dea.total_deaths, dea.total_cases


--Basic Data

Select *, (RollingPeopleVaccinated/population)*100 as RollingPercentOfPeopleVaccinated
From #PercentPopulationVaccinated


Select dea.continent, dea.location, dea.date, dea.new_cases, dea.new_deaths,vac.total_vaccinations, MAX((dea.total_cases/dea.population))*100 as PercentPopulatoinInfected, MAX((vac.total_vaccinations/dea.population))*100 as PercentPopulatoinVaccinated, (dea.total_deaths/dea.total_cases)*100 as DeathRate
From [Portfolio Poject]..CovidDeaths dea
Join [Portfolio Poject]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent like '%Asia%'
Group by dea.continent, dea.Location, dea.date, dea.population, dea.new_cases,dea.new_deaths,vac.total_vaccinations, dea.total_cases, dea.total_deaths
order by 2,3

Select continent, MAX(Total_cases) as TotalCases
From [Portfolio Poject]..CovidDeaths
Where continent is not null
group by continent


-- Views



Create View PercentPopulationVaccinated as
Select dea.continent, dea.Location, dea.date, dea.population,vac.new_vaccinations, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
From [Portfolio Poject]..CovidDeaths dea
Join [Portfolio Poject]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Group by dea.continent, dea.Location, dea.date, dea.population, dea.new_cases,dea.new_deaths, vac.new_vaccinations,vac.total_vaccinations, dea.total_deaths, dea.total_cases



Create View TotalCasesByContinent as
Select continent, MAX(Total_cases) as TotalCases
From [Portfolio Poject]..CovidDeaths
Where continent is not null
Group by continent
