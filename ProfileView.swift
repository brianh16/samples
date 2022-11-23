//
//  ProfileView.swift
//  relsto
//
//  Created by Brian Michael on 10/16/22.
//

import SwiftUI
import MessageUI
import UIKit

struct ProfileView: View {
    @StateObject var viewRouter: ViewRouter
    @State var currentPage: Page = .profile
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    var body: some View {
            VStack{
                HStack{
                    Text("Profile")
                        .padding(.horizontal, 20)
                    Spacer()
                    Text("")
                    
                }.ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .background(Color.white)
                    .font(.title3.bold())
                    .foregroundColor(Color.black)
                    .padding(.bottom, 40)
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 125, height: 125, alignment: .center)
                Text((UserDefaults.standard.string(forKey: "Firstname") ?? "") + " " + (UserDefaults.standard.string(forKey: "Lastname") ?? ""))
                    .font(.title.bold())
                HStack(alignment: .center) {

                    VStack(alignment: .leading) {
                        Text("Profile Information")
                            .font(.system(size: 26, weight: .bold, design: .default))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 15)
                            .padding(.top, 10)
                        HStack {
                            Text("Email")
                                .font(.title3.bold())
                                .padding(.bottom, 5)
                                .padding(.horizontal, 10)
                                .foregroundColor(.black)
                            Spacer()
                            Text("\(UserDefaults.standard.string(forKey: "Email") ?? "")")
                                .padding(.bottom, 5)
                                
                        }
                        HStack {
                            Text("Fare Type")
                                .font(.title3.bold())
                                .padding(.bottom, 5)
                                .padding(.horizontal, 10)
                                .foregroundColor(.black)
                            Spacer()
                            Text("\(UserDefaults.standard.string(forKey: "Agelevel") ?? "")")
                                .padding(.bottom, 5)
                        }
                        HStack {
                            Text("Transit System")
                                .font(.title3.bold())
                                .padding(.bottom, 5)
                                .padding(.horizontal, 10)
                                .foregroundColor(.black)
                            Spacer()
                            Text("\(UserDefaults.standard.string(forKey: "BusPlace") ?? "")")
                                .padding(.bottom, 5)
                        }
                    }.padding(.trailing, 20)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(Color.white)
                .modifier(CardModifier())
                .padding(.all, 10)
                List{
                    Button(action: {self.isShowingMailView.toggle()}) {
                        Text("Contact us")
                    }.disabled(!MFMailComposeViewController.canSendMail())
                        .sheet(isPresented: $isShowingMailView) {
                            MailView(result: self.$result)
                        }
                    Button(action: {self.isShowingMailView.toggle()}) {
                        Text("Report a problem")
                    }.disabled(!MFMailComposeViewController.canSendMail())
                        .sheet(isPresented: $isShowingMailView) {
                            MailView(result: self.$result)
                        }
                    Link("Learn more", destination: URL(string: "https://www.getfairbox.com/features")!)
                }.frame(width: nil, height: 200, alignment: .center)
                Spacer()
            }
        }

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewRouter: ViewRouter())
    }
}

struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject("Contact Us")
        vc.setToRecipients(["customersupport@relsto.com"])
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}
