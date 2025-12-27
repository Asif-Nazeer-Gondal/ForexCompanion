import httpx
from typing import List, Dict, Any
from core.logger import logger
from datetime import datetime, timedelta

class EconomicCalendarService:
    def __init__(self):
        # In a real app, you would use an API key from a provider like FinancialModelingPrep or similar
        self.base_url = "https://api.example.com/v1/calendar" 
        self.impact_levels = {"LOW": 1, "MEDIUM": 2, "HIGH": 3}
        self._cache: Dict[str, tuple[datetime, List[Dict[str, Any]]]] = {}
        self._cache_ttl = timedelta(minutes=60)

    async def get_events(self, symbol: str, min_impact: str = "LOW") -> List[Dict[str, Any]]:
        """
        Fetches economic events relevant to the given symbol for the current week.
        """
        cache_key = f"{symbol}_{min_impact}"
        if cache_key in self._cache:
            timestamp, cached_data = self._cache[cache_key]
            if datetime.now() - timestamp < self._cache_ttl:
                logger.info(f"Returning cached economic events for {symbol}")
                return cached_data

        # Extract currencies from symbol (e.g., "EUR_USD" -> ["EUR", "USD"])
        currencies = symbol.split('_')
        
        # Mock implementation for demonstration
        # In production, make an HTTP request here
        logger.info(f"Fetching economic events for {currencies} with min_impact={min_impact}")
        
        # Simulate API delay
        # await asyncio.sleep(0.5)
        
        # Return mock data based on currencies
        events = []
        
        if "USD" in currencies:
            events.append({
                "title": "Non-Farm Payrolls",
                "currency": "USD",
                "impact": "HIGH",
                "actual": "250K",
                "forecast": "180K",
                "previous": "150K",
                "time": (datetime.now() + timedelta(hours=2)).isoformat()
            })
            events.append({
                "title": "Initial Jobless Claims",
                "currency": "USD",
                "impact": "MEDIUM",
                "actual": "210K",
                "forecast": "215K",
                "previous": "220K",
                "time": (datetime.now() - timedelta(hours=24)).isoformat()
            })
            
        if "EUR" in currencies:
            events.append({
                "title": "ECB Interest Rate Decision",
                "currency": "EUR",
                "impact": "HIGH",
                "actual": "4.5%",
                "forecast": "4.5%",
                "previous": "4.25%",
                "time": (datetime.now() - timedelta(hours=4)).isoformat()
            })
            events.append({
                "title": "German Industrial Production",
                "currency": "EUR",
                "impact": "LOW",
                "actual": "-0.4%",
                "forecast": "-0.2%",
                "previous": "-0.1%",
                "time": (datetime.now() - timedelta(hours=48)).isoformat()
            })
            
        # Filter events based on impact
        filtered_events = [
            event for event in events 
            if self._is_impact_significant(event.get("impact", "LOW"), min_impact)
        ]
        
        self._cache[cache_key] = (datetime.now(), filtered_events)
            
        return filtered_events

    def _is_impact_significant(self, event_impact: str, min_impact: str) -> bool:
        return self.impact_levels.get(event_impact.upper(), 0) >= self.impact_levels.get(min_impact.upper(), 0)

    # async def _fetch_from_api(self, currencies: List[str]) -> List[Dict[str, Any]]:
    #     ...