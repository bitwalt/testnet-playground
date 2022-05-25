from time import sleep
import codecs
import lightning_pb2 as ln
import lightning_pb2_grpc as lnrpc
from loguru import logger
import grpc
import os

# Update to Schnorr  
os.environ["GRPC_SSL_CIPHER_SUITES"] = 'HIGH+ECDSA'


class LightningWallet:
    """ A lightning wallet for streaming data. """

    def __init__(self, name: str, host:str, port:int):
        self.name = name
        self.host = host
        self.port = port
        self.macaroon_path = os.path.expanduser(f'/lnd_share/{self.name}/admin.macaroon')
        self.certificate_path = os.path.expanduser(f'/lnd_share/{self.name}/tls.cert')
        
    def connect(self, use_macaroon=True):
        cert = open(self.certificate_path, 'rb').read()
        cert_creds = grpc.ssl_channel_credentials(cert)
        if use_macaroon:        
            auth_creds = grpc.metadata_call_credentials(self.metadata_callback)
            cert_creds = grpc.composite_channel_credentials(cert_creds, auth_creds)
        self.channel = grpc.secure_channel(f'{self.host}:{str(self.port)}', cert_creds)
        self.stub = lnrpc.LightningStub(self.channel)
        logger.info("Connected to LND node")
    
    def metadata_callback(self, context, callback):
        macaroon = self.get_macaroon()
        if macaroon is None:
            raise Exception("Macaroon doesn't exist")
        else:
            callback([('macaroon', macaroon)], None)


    def get_macaroon(self):
        macaroon = None
        with open(self.macaroon_path, 'rb') as f:
            macaroon_bytes = f.read()
            macaroon = codecs.encode(macaroon_bytes, 'hex')
        return macaroon
    
    def get_info(self):
        # now every call will be made with the macaroon already included
        info = self.stub.GetInfo(ln.GetInfoRequest())
        return info
        
    def generate_invoice(self, amt):
        """ Generate an invoice for the amount. """
        response = self.stub.AddInvoice(ln.Invoice(value=amt))
        logger.info(f"Invoice created: {response}")
        return response.payment_request
    
    def response_streaming(self):
        request = ln.InvoiceSubscription()
        for invoice in self.stub.SubscribeInvoices(request):
            print(invoice)

    def get_total_balance(self):
        # Retrieve and display the wallet balance
        response = self.stub.WalletBalance(ln.WalletBalanceRequest())
        return response.total_balance


    def request_generator(dest, amt):
        # Initialization code here
        counter = 0
        print("Starting up")
        while True:
            request = ln.SendRequest(dest=dest, amt=amt,)
            yield request
            counter += 1
            sleep(2)
            
    # Send a payment of 100 satoshis every 2 seconds.
    def create_streaming_payment(self, dest_pub_key_hex, amount=100):
        # Outputs from lncli are hex-encoded
        dest_bytes = codecs.decode(dest_pub_key_hex, 'hex')
        request_iterable = self.request_generator(dest=dest_bytes, amt=amount)
        for payment in self.stub.SendPayment(request_iterable):
            print(payment)
    
    
if __name__ == '__main__':
    lnd_wallet  = LightningWallet("lnd_wallet", "localhost", 10008)
    # Connect to Bob securely
    lnd_wallet.connect_to_node("localhost", 10009, use_macaroon=True)
    # Connect to Charlie not securely
    lnd_wallet.connect_to_node("localhost", 10010, use_macaroon=False)