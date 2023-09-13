import 'package:flutter/material.dart';

class TermsConditon extends StatelessWidget {
  const TermsConditon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.black,
        title: const Text(
          "Terms and Conditions",
          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
            '''                                   
                                  Introduction 
        
        
        Welcome to Infinity Player App,\n
            These Terms of Service govern your use of our website located at lala.com (together or individually “Service”) operated by Infinity Player App.\n
            Our Privacy Policy also governs your use of our Service and explains how we collect, safeguard and disclose information that results from your use of our web pages.
            
1.Agreement

            Your agreement with us includes these Terms and our Privacy Policy (“Agreements”). You acknowledge that you have read and understood Agreements, and agree to be bound of them.
            If you do not agree with (or cannot comply with) Agreements, then you may not use the Service, but please let us know by emailing at afilahamed0007@gmail.com so we can try to find a solution. These Terms apply to all visitors, users and others who wish to access or use Service.
                       
2. Content 
        
            content found on or through this Service are the property of Infinity Player App or used with permission. You may not distribute, modify, transmit, reuse, download, repost, copy, or use said Content, whether in whole or in part, for commercial purposes or for personal gain, without express advance written permission from us.
            
3. Prohibited Uses
        
            You may use Service only for lawful purposes and in accordance with Terms. You agree not to use Service:
            0.1. In any way that violates any applicable national or international law or regulation.
            0.2. For the purpose of exploiting, harming, or attempting to exploit or harm minors in any way by exposing them to inappropriate content or otherwise.
            0.3. To transmit, or procure the sending of, any advertising or promotional material, including any “junk mail”, “chain letter,” “spam,” or any other similar solicitation.
            0.4. To impersonate or attempt to impersonate Company, a Company employee, another user, or any other person or entity.
            0.5. In any way that infringes upon the rights of others, or in any way is illegal, threatening, fraudulent, or harmful, or in connection with any unlawful, illegal, fraudulent, or harmful purpose or activity.
            0.6. To engage in any other conduct that restricts or inhibits anyone’s use or enjoyment of Service, or which, as determined by us, may harm or offend Company or users of Service or expose them to liability.
            Additionally, you agree not to:
                                
4. No Use By Minors
        
            Service is intended only for access and use by individuals at least eighteen (18) years old. By accessing or using Service, you warrant and represent that you are at least eighteen (18) years of age and with the full authority, right, and capacity to enter into this agreement and abide by all of the terms and conditions of Terms. If you are not at least eighteen (18) years old, you are prohibited from both the access and usage of Service.
                      
5. Copyright Policy
        
            We respect the intellectual property rights of others. It is our policy to respond to any claim that Content posted on Service infringes on the copyright or other intellectual property rights (“Infringement”) of any person or entity.
            If you are a copyright owner, or authorized on behalf of one, and you believe that the copyrighted work has been copied in a way that constitutes copyright infringement, please submit your claim via email to afilahamed0007@gmail.com, with the subject line: “Copyright Infringement” and include in your claim a detailed description of the alleged Infringement as detailed below, under “DMCA Notice and Procedure for Copyright Infringement Claims”
            You may be held accountable for damages (including costs and attorneys fees) for misrepresentation or bad-faith claims on the infringement of any Content found on and/or through Service on your copyright.
            
6. DMCA Notice and Procedure for Copyright Infringement Claims
        
            You may submit a notification pursuant to the Digital Millennium Copyright Act (DMCA) by providing our Copyright Agent with the following information in writing (see 17 U.S.C 512(c)(3) for further detail):
            0.1. an electronic or physical signature of the person authorized to act on behalf of the owner of the copyright’s interest;
            0.2. a description of the copyrighted work that you claim has been infringed, including the URL (i.e., web page address) of the location where the copyrighted work exists or a copy of the copyrighted work;
            0.3. identification of the URL or other specific location on Service where the material that you claim is infringing is located;
            0.4. your address, telephone number, and email address;
            0.5. a statement by you that you have a good faith belief that the disputed use is not authorized by the copyright owner, its agent, or the law;
            0.6. a statement by you, made under penalty of perjury, that the above information in your notice is accurate and that you are the copyright owner or authorized to act on the copyright owners behalf.
            You can contact our Copyright Agent via email at afilahamed0007@gmail.com.
            
7. Error Reporting and Feedback
        
            You may provide us either directly at afilahamed0007@gmail.com or via third party sites and tools with information and feedback concerning errors, suggestions for improvements, ideas, problems, complaints, and other matters related to our Service (“Feedback”). You acknowledge and agree that: (i) you shall not retain, acquire or assert any intellectual property right or other right, title or interest in or to the Feedback; (ii) Company may have development ideas similar to the Feedback; (iii) Feedback does not contain confidential information or proprietary information from you or any third party; and (iv) Company is not under any obligation of confidentiality with respect to the Feedback. In the event the transfer of the ownership to the Feedback is not possible due to applicable mandatory laws, you grant Company and its affiliates an exclusive, transferable, irrevocable, free-of-charge, sub-licensable, unlimited and perpetual right to use (including copy, modify, create derivative works, publish, distribute and commercialize) Feedback in any manner and for any purpose.
                                                                  
8. Amendments To Terms
        
            We may amend Terms at any time by posting the amended terms on this site. It is your responsibility to review these Terms periodically.
            Your continued use of the Platform following the posting of revised Terms means that you accept and agree to the changes. You are expected to check this page frequently so you are aware of any changes, as they are binding on you.
            By continuing to access or use our Service after any revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, you are no longer authorized to use Service.
                       
9. Acknowledgement
        
            BY USING SERVICE OR OTHER SERVICES PROVIDED BY US, YOU ACKNOWLEDGE THAT YOU HAVE READ THESE TERMS OF SERVICE AND AGREE TO BE BOUND BY THEM.
            
10. Contact Us
        
            Please send your feedback, comments, requests for technical support by email: afilahamed0007@gmail.com.
            
                    ''',
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}
