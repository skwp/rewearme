require 'money/bank/open_exchange_rates_bank'

def Money.use_static_rates
  Rails.logger.info "Could not connect to exchange rate server. Using static exchange rates..."
  Money.add_rate("GBP", "USD", 1.6223)
  Money.add_rate("USD", "GBP", 1/1.6223)
  Money.add_rate("AUD", "USD", 1.0562)
  Money.add_rate("USD", "AUD", 1/1.0562)
  Money.add_rate("USD", "EUR", 0.7744)
  Money.add_rate("EUR", "USD", 1/0.7744)
  Money.add_rate("AUD", "GBP", 0.6511)
  Money.add_rate("GBP", "AUD", 1/0.6511)
end

if ['development', 'test'].include?(Rails.env) 
  Money.use_static_rates
else
  Rails.logger.info "Updating exchange rates..."
  begin
    moe = Money::Bank::OpenExchangeRatesBank.new
    moe.cache = File.join(Rails.root, "tmp/exchange_rates")
    moe.update_rates
  rescue
    Money.use_static_rates
  end
  Rails.logger.info "Updating exchange rates done."

  Money.default_bank = moe
end

