import logging
import sentry_sdk

def init_logging():
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s-%(name)s-%(levelname)s-%(message)s',
        datefmt='%m-%d %H:%M'
    )

def init_sentry():
    sentry_sdk.init(
        dsn="https://711858d8b656e8ee803dcb1e8b549594@o4511263521505280.ingest.de.sentry.io/4511263607488592",
        traces_sample_rate=1.0
    )

def test_division_error():
    division_by_zero = 1 / 0

def test_type_error():
    x = "string" + 5

def main():
    init_logging()
    init_sentry()
    test_division_error()
    test_type_error()




































if __name__ == "__main__":
    main()
